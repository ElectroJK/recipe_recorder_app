class Recipe {
  final String id;
  final String title;
  final String description;
  final String image;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Recipe && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
