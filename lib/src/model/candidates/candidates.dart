// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'candiate.dart';

class Candidates {
  Candidates({
    List<Candidate>? candidates,
    this.allUploaded,
  }) : candidates = candidates ?? [];

  final List<Candidate> candidates;
  final bool? allUploaded;

  Candidates copyWith({
    List<Candidate>? candidates,
    bool? allUploaded,
  }) {
    return Candidates(
      candidates: candidates ?? this.candidates,
      allUploaded: allUploaded ?? this.allUploaded,
    );
  }

  bool get hascandidates => candidates.isNotEmpty;

  Candidates add(List<Candidate> newcandidates) {
    final uniqueCandidates =
        newcandidates.where((e) => !candidates.contains(e));

    return Candidates(
      allUploaded: false,
      candidates: [
        ...{...candidates, ...uniqueCandidates}
      ],
    );
  }

  Candidates remove(Candidate item) {
    final remaining = candidates.where((element) => item != element).toList();
    return copyWith(
      candidates: remaining,
      allUploaded: remaining.isEmpty,
    );
  }

  Candidates removeMultiple(List<Candidate> candidates) {
    final remaining =
        candidates.where((element) => !candidates.contains(element)).toList();
    return copyWith(
      candidates: remaining,
      allUploaded: remaining.isEmpty,
    );
  }

  List<Candidate> getSelected() {
    return candidates.where((element) => element.isSelected).toList();
  }

  toggleSelection(Candidate candidate) {
    return copyWith(
      candidates: candidates
          .map(
            (e) => (e == candidate) ? candidate.toggleSelection() : e,
          )
          .toList(),
    );
  }

  Candidates selectAll() {
    return copyWith(
      candidates: candidates
          .map(
            (e) => e.copyWith(isSelected: true),
          )
          .toList(),
    );
  }

  Candidates selectNone() {
    return copyWith(
      candidates: candidates
          .map(
            (e) => e.copyWith(isSelected: false),
          )
          .toList(),
    );
  }

  Candidates removeSelected() {
    final remaining =
        candidates.where((element) => !element.isSelected).toList();
    return copyWith(
      allUploaded: remaining.isEmpty,
      candidates: remaining,
    );
  }
}
