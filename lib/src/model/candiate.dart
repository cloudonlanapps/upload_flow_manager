// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:upload_flow_manager/src/view/candidate_picker.dart';

class Candidate {
  final bool isSelected;
  final MediaItem item;

  Candidate({
    required this.item,
    this.isSelected = true,
  });

  Candidate copyWith({
    bool? isSelected,
    MediaItem? item,
  }) {
    return Candidate(
      isSelected: isSelected ?? this.isSelected,
      item: item ?? this.item,
    );
  }

  Candidate toggleSelection() => copyWith(isSelected: !isSelected);

  @override
  String toString() => 'Candidate(isSelected: $isSelected, item: $item)';

  @override
  bool operator ==(covariant Candidate other) {
    if (identical(this, other)) return true;

    return other.isSelected == isSelected && other.item == item;
  }

  @override
  int get hashCode => isSelected.hashCode ^ item.hashCode;
}
