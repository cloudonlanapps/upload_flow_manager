// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqlite3/sqlite3.dart';

import '../db/db.dart';

import '../defaults/http_uploader.dart';
import '../export/config.dart';

import '../providers/queue.dart';

class CLUploader extends ConsumerWidget {
  const CLUploader({
    super.key,
    required this.builder,
    required this.errorBuilder,
    required this.loadingBuilder,
    required this.uploadConfig,
  });
  final Widget Function() builder;
  final Widget Function(Object, StackTrace) errorBuilder;
  final Widget Function() loadingBuilder;
  final UploadConfig uploadConfig;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<Database> dbAsync =
        ref.watch(dbProvider(uploadConfig.sqlite3LibOverrider));
    return dbAsync.when(
        data: (db) {
          final uploadHandler = uploadConfig.uploadHandler ??
              UploadManagerUsingHttp(
                  url: uploadConfig.url, fileField: uploadConfig.fileField);
          return ProviderScope(observers: const [], overrides: [
            uploadQueueNotifierProvider.overrideWith((ref) {
              final notifier = UploadQueueNotifier(
                  uploadManager: uploadHandler, database: db);
              uploadHandler.onSubscribe(
                updateProgress: notifier.updateProgress,
                updateStatus: notifier.updateStatus,
              );
              ref.onDispose(() {
                uploadHandler.onCancelSubscribe();
              });

              return notifier;
            }),
          ], child: builder());
        },
        error: errorBuilder,
        loading: loadingBuilder);
  }
}

/*



*/