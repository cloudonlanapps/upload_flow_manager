// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqlite3/sqlite3.dart';

import '../db/db.dart';

import '../export/config.dart';

import '../providers/queue.dart';

class UploaderScope extends ConsumerWidget {
  const UploaderScope({
    super.key,
    required this.child,
    required this.errorBuilder,
    required this.loadingBuilder,
    required this.uploadHandler,
    this.sqlite3LibOverrider,
  });
  final Widget child;
  final Widget Function(Object, StackTrace) errorBuilder;
  final Widget Function() loadingBuilder;
  final UploadHandler uploadHandler;
  final Function()? sqlite3LibOverrider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<Database> dbAsync =
        ref.watch(dbProvider(sqlite3LibOverrider));
    return dbAsync.when(
        data: (db) {
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
          ], child: child);
        },
        error: errorBuilder,
        loading: loadingBuilder);
  }
}

/*



*/