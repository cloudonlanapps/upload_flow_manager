// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqlite3/sqlite3.dart';

import '../db/db.dart';
import '../model/config.dart';
import '../provider/config.dart';
import '../provider/queue.dart';
import 'error.dart';
import 'loading.dart';
import 'uploader_view.dart';

class UploaderMain extends ConsumerWidget {
  const UploaderMain({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UploadConfig cfg = ref.watch(uploadConfigProvider);
    final AsyncValue<Database> dbAsync =
        ref.watch(dbProvider(cfg.sqlite3LibOverrider));
    return dbAsync.when(
        data: (db) {
          return ProviderScope(observers: const [], overrides: [
            uploadQueueNotifierProvider.overrideWith((ref) {
              final notifier = UploadQueueNotifier(
                  uploadManager: cfg.uploadHandler, database: db);
              cfg.uploadHandler.onSubscribe(
                updateProgress: notifier.updateProgress,
                updateStatus: notifier.updateStatus,
              );
              ref.onDispose(() {
                cfg.uploadHandler.onCancelSubscribe();
              });

              return notifier;
            }),
          ], child: const UploaderView());
        },
        error: (err, _) {
          return ErrorView(errorMessage: err.toString());
        },
        loading: () => const LoadingView());
  }
}
