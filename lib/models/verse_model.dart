class Verse {
  final int number;
  final String text;

  Verse({
    required this.number,
    required this.text,
  });

  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      number: int.parse(json['ref'] as String), // Mapeado para 'ref' e convertido para int
      text: json['text'] as String,
    );
  }
}
