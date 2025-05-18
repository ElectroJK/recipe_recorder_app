class Recipe {
  final String id;
  final String title;
  final String description;
  final String image;
  final bool favorites;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    this.favorites = false,
  });

  Recipe copyWith({
    String? id,
    String? title,
    String? description,
    String? image,
    bool? favorites,
  }) {
    return Recipe(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      image: image ?? this.image,
      favorites: favorites ?? this.favorites,
    );
  }
}
