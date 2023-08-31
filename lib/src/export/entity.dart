// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'status.dart';

class UploadEntity {
  final int? id;
  final String path;
  final String aux;
  final DateTime time;
  final UploadStatus uploadStatus;
  final double progress;
  final String? serverResponse;
  final bool isScheduled;

  UploadEntity({
    this.id,
    required this.path,
    required this.aux,
    required this.time,
    required this.uploadStatus,
    required this.progress,
    required this.serverResponse,
    required this.isScheduled,
  });

  UploadEntity copyWith({
    int? id,
    String? path,
    String? aux,
    DateTime? time,
    UploadStatus? uploadStatus,
    double? progress,
    String? serverResponse,
    bool? isScheduled,
  }) {
    return UploadEntity(
      id: id ?? this.id,
      path: path ?? this.path,
      aux: aux ?? this.aux,
      time: time ?? this.time,
      uploadStatus: uploadStatus ?? this.uploadStatus,
      progress: progress ?? this.progress,
      serverResponse: serverResponse ?? this.serverResponse,
      isScheduled: isScheduled ?? this.isScheduled,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'path': path,
      'aux': aux,
      'time': time.millisecondsSinceEpoch,
      'uploadStatus': uploadStatus.index,
      'progress': progress,
      'isScheduled': isScheduled,
      'serverResponse': serverResponse,
    };
  }

  factory UploadEntity.fromMap(Map<String, dynamic> map) {
    return UploadEntity(
        id: map['id'] != null ? map['id'] as int : null,
        path: map['path'] as String,
        aux: map['aux'] as String,
        time: DateTime.fromMillisecondsSinceEpoch(map['time'] as int),
        uploadStatus: UploadStatus.values[map['uploadStatus']],
        progress: map['progress'] as double,
        isScheduled: map['isScheduled'] as bool,
        serverResponse: map['serverResponse'] != null
            ? map['serverResponse'] as String
            : null);
  }

  String toJson() => json.encode(toMap());

  factory UploadEntity.fromJson(String source) =>
      UploadEntity.fromMap(json.decode(source) as Map<String, dynamic>);
}
