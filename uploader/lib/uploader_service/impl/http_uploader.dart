import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../models/entity.dart';
import '../models/status.dart';
import '../models/upload_manager.dart';

class UploadManagerUsingHttp extends UploadManager {
  UploadManagerUsingHttp({required super.config}) {
    onEvent.listen((event) async {
      if (!isProcessing) {
        isProcessing = true;
        await processQueue();
        isProcessing = false;
      }
    });
  }

  StreamController<String> checkQueueEventController =
      StreamController.broadcast();
  bool isProcessing = false;
  Queue<UploadEntity> queue = Queue();

  Stream<String> get onEvent => checkQueueEventController.stream;
  Uri get uri => Uri.parse(config.url);
  Future<void> processQueue() async {
    while (queue.isNotEmpty) {
      final entity = queue.removeFirst();
      await fileUpload(entity);
    }
  }

  @override
  Future<void> scheduleUpload(UploadEntity entity) async {
    queue.addLast(entity);
    updateStatus?.call(entity.id!, status: UploadStatus.enqueued);
    checkQueueEventController.add('New Item Added');
  }

  static bool trustSelfSigned = true;

  static HttpClient getHttpClient() {
    final httpClient = HttpClient()
      ..connectionTimeout = const Duration(seconds: 10)
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => trustSelfSigned);

    return httpClient;
  }

  Future<void> fileUpload(UploadEntity entity) async {
    //Send status change callback here
    try {
      updateStatus?.call(entity.id!, status: UploadStatus.running);

      final request = MultipartRequest(
        'POST',
        uri,
        onProgress: (int bytes, int total) {
          final progress = bytes / total;
          updateProgress?.call(entity.id!, progress);
        },
      );
      final itemMap = jsonDecode(entity.itemJson) as Map<String, String?>;
      // request.headers['HeaderKey'] = 'header_value';
      // request.fields['form_key'] = 'form_value';
      if (itemMap.containsKey(config.fileField)) {
        request.files.add(
          await http.MultipartFile.fromPath(
            config.fileField,

            itemMap[config.fileField]!, //
          ),
        );
      }
      final streamedResponse = await request.send();
      streamedResponse.stream.listen((value) {
        updateStatus?.call(entity.id!, status: UploadStatus.complete);
      });
    } catch (e) {
      updateStatus?.call(entity.id!, status: UploadStatus.failed);
    }
  }
}

class MultipartRequest extends http.MultipartRequest {
  /// Creates a new [MultipartRequest].
  MultipartRequest(
    super.method,
    super.url, {
    this.onProgress,
  });

  final void Function(int bytes, int totalBytes)? onProgress;

  /// Freezes all mutable fields and returns a single-subscription [http.ByteStream]
  /// that will emit the request body.
  @override
  http.ByteStream finalize() {
    final byteStream = super.finalize();
    if (onProgress == null) return byteStream;

    final total = contentLength;
    var bytes = 0;

    final t = StreamTransformer.fromHandlers(
      handleData: (List<int> data, EventSink<List<int>> sink) {
        bytes += data.length;
        onProgress?.call(bytes, total);
        if (total >= bytes) {
          sink.add(data);
        }
      },
    );
    final stream = byteStream.transform(t);
    return http.ByteStream(stream);
  }
}
