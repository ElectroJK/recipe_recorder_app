class Recipe {
  final String id;
  final String title;
  final String description;
  final String image;
  final bool favorites;
  final String ingredients;
  final String category;
  final String area;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    this.favorites = false,
    this.ingredients = '',
    this.category = '',
    this.area = '',
  });

  Recipe copyWith({
    String? id,
    String? title,
    String? description,
    String? image,
    bool? favorites,
    String? ingredients,
    String? category,
    String? area,
  }) {
    return Recipe(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      image: image ?? this.image,
      favorites: favorites ?? this.favorites,
      ingredients: ingredients ?? this.ingredients,
      category: category ?? this.category,
      area: area ?? this.area,
    );
  }
}
