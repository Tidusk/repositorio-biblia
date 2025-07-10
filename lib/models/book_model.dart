class Book {
  final String abbrev; // Alterado de int para String
  final String name;
  final int chapters;

  Book({
    required this.abbrev,
    required this.name,
    required this.chapters,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      abbrev: json['ref'] as String, // Mapeado para 'ref'
      name: json['name'] as String,
      chapters: json['chaptersCount'] as int, // Mapeado para 'chaptersCount'
    );
  }
}
