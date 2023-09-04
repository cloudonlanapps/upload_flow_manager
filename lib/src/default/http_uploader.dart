import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:upload_flow_manager/upload_flow_manager.dart';

class UploadManagerUsingHttp extends UploadHandler {
  UploadManagerUsingHttp({required url, String? fileField}) {
    this.url = url;
    this.fileField = fileField ?? "file";
    onEvent.listen((event) async {
      if (!listererLock) {
        listererLock = true;
        await processQueue();
        listererLock = false;
      }
    });
  }

  StreamController checkQueueEventController = StreamController.broadcast();
  bool listererLock = false;
  Queue<UploadEntity> queue = Queue();

  Stream get onEvent => checkQueueEventController.stream;
  Uri get uri => Uri.parse(url);
  processQueue() async {
    while (queue.isNotEmpty) {
      UploadEntity entity = queue.removeFirst();
      await fileUpload(entity);
    }
  }

  @override
  Future<void> scheduleUpload(UploadEntity entity) async {
    queue.addLast(entity);
    updateStatus?.call(entity.id!, status: UploadStatus.enqueued);
    checkQueueEventController.add("New Item Added");
  }

  static bool trustSelfSigned = true;

  static HttpClient getHttpClient() {
    HttpClient httpClient = HttpClient()
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
      // request.headers['HeaderKey'] = 'header_value';
      // request.fields['form_key'] = 'form_value';
      request.files.add(
        await http.MultipartFile.fromPath(fileField, entity.path),
      );
      final http.StreamedResponse streamedResponse = await request.send();
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
    String method,
    Uri url, {
    this.onProgress,
  }) : super(method, url);

  final void Function(int bytes, int totalBytes)? onProgress;

  /// Freezes all mutable fields and returns a single-subscription [ByteStream]
  /// that will emit the request body.
  @override
  http.ByteStream finalize() {
    final byteStream = super.finalize();
    if (onProgress == null) return byteStream;

    final total = contentLength;
    int bytes = 0;

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
