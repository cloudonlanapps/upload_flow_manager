// ignore_for_file: public_member_api_docs, sort_constructors_first

class Candidate {
  final bool isSelected;
  final String path;

  Candidate({
    this.isSelected = true,
    required this.path,
  });

  Candidate copyWith({
    bool? isSelected,
    String? path,
  }) {
    return Candidate(
      isSelected: isSelected ?? this.isSelected,
      path: path ?? this.path,
    );
  }

  Candidate toggleSelection() => copyWith(isSelected: !isSelected);

  @override
  String toString() => 'Candidate(isSelected: $isSelected, path: $path)';

  @override
  bool operator ==(covariant Candidate other) {
    if (identical(this, other)) return true;

    return other.path == path;
  }

  @override
  int get hashCode => path.hashCode;
}
