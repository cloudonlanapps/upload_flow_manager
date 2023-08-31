// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqlite3/sqlite3.dart';

import '../db/db.dart';
import '../export/config.dart';
import '../provider/queue.dart';
import 'error.dart';
import 'loading.dart';
import 'uploader_view.dart';

class UploaderMain extends ConsumerWidget {
  final UploadConfig cfg;

  const UploaderMain({
    super.key,
    required this.cfg,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<Database> dbAsync = ref.watch(dbProvider);
    return dbAsync.when(
        data: (db) {
          return ProviderScope(observers: const [], overrides: [
            uploadConfigProvider.overrideWith((ref) => cfg),
            uploadQueueNotifierProvider.overrideWith((ref) {
              final notifier = UploadQueueNotifier(
                  uploadManager: cfg.uploadManager, database: db);
              cfg.uploadManager.onSubscribe(
                updateProgress: notifier.updateProgress,
                updateStatus: notifier.updateStatus,
              );
              ref.onDispose(() {
                cfg.uploadManager.onCancelSubscribe();
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
