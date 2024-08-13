// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:upload_flow_manager/src/view/candidate_picker.dart';

import '../model/candiate.dart';
import '../model/candidates.dart';

class UploadCandidatesNotifier extends StateNotifier<Candidates> {
  UploadCandidatesNotifier() : super(Candidates());

  void add(List<MediaItem> files) {
    final uploadCandidate = <Candidate>[];
    for (var i = 0; i < files.length; i++) {
      uploadCandidate.add(Candidate(item: files[i]));
    }

    state = state.add(uploadCandidate);
  }

  /* bool remove(Candidate candidate) {
    state = state.remove(candidate);
    return state.allUploaded!;
  } */

  /* bool removeMultiple(List<Candidate> candidates) {
    state = state.removeMultiple(candidates);
    return state.allUploaded!;
  } */

  bool removeSelected() {
    state = state.removeSelected();
    return state.allUploaded!;
  }

  void toggleSelection(Candidate candidate) {
    state = state.toggleSelection(candidate);
  }

  void selectAll() {
    state = state.selectAll();
  }

  void selectNone() {
    state = state.selectNone();
  }
}

final uploadCandidatesNotifierProvider =
    StateNotifierProvider<UploadCandidatesNotifier, Candidates>((ref) {
  return UploadCandidatesNotifier();
});
