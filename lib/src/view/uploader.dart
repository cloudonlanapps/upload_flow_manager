// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:upload_flow_manager/src/view/candidate_picker.dart';
import 'package:uploader/uploader.dart';

import '../db/db.dart';
import '../model/candiate.dart';
import '../model/candidates.dart';
import '../provider/candidates.dart';

class CLUploader extends ConsumerWidget {
  const CLUploader({
    super.key,
    required this.builder,
    required this.errorBuilder,
    required this.loadingBuilder,
    required this.uploadConfig,
  });
  final Widget Function({
    required Candidates candidates,
    required List<UploadEntity> queue,
    required void Function() onRetry,
    required void Function() onRemoveAll,
    required void Function() onRemoveCompleted,
  }) builder;
  final Widget Function(Object, StackTrace) errorBuilder;
  final Widget Function() loadingBuilder;
  final UploadConfig uploadConfig;

  static void addCandidates(WidgetRef ref, List<MediaItem> candidates) {
    ref.read(uploadCandidatesNotifierProvider.notifier).add(candidates);
  }

  static void onSelect(WidgetRef ref, Candidate candidate) {
    ref
        .read(uploadCandidatesNotifierProvider.notifier)
        .toggleSelection(candidate);
  }

  static void onSelectAll(
    WidgetRef ref,
  ) {
    ref.read(uploadCandidatesNotifierProvider.notifier).selectAll();
  }

  static onClearSelection(WidgetRef ref) {
    ref.read(uploadCandidatesNotifierProvider.notifier).selectNone();
  }

  static bool onUpload(WidgetRef ref, List<Candidate> uploadCandidates) {
    ref
        .read(uploadQueueNotifierProvider.notifier)
        .addCandidates(uploadCandidates.map((e) => e.item).toList());
    final allUploaded =
        ref.read(uploadCandidatesNotifierProvider.notifier).removeSelected();
    return allUploaded;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<Database> dbAsync =
        ref.watch(dbProvider1(uploadConfig.sqlite3LibOverrider));

    // Create a child widget!!
    final Candidates candidates = ref.watch(uploadCandidatesNotifierProvider);
    final AsyncValue<List<UploadEntity>> uploadQueueAsync =
        ref.watch(uploadQueueNotifierProvider);

    return dbAsync.when(
        data: (db) {
          final uploadHandler = UploadManagerUsingHttp(config: uploadConfig);
          return ProviderScope(
              observers: const [],
              overrides: [
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
              ],
              child: uploadQueueAsync.when(
                  data: (queue) => builder(
                      candidates: candidates,
                      queue: queue,
                      onRemoveAll: () {
                        ref
                            .read(uploadQueueNotifierProvider.notifier)
                            .removeAll();
                      },
                      onRemoveCompleted: () {
                        ref
                            .read(uploadQueueNotifierProvider.notifier)
                            .removeCompleted();
                      },
                      onRetry: () {
                        ref
                            .read(uploadQueueNotifierProvider.notifier)
                            .refresh(); // TODO: Change to retry
                      }),
                  error: errorBuilder,
                  loading: loadingBuilder));
        },
        error: errorBuilder,
        loading: loadingBuilder);
  }
}

/*



*/