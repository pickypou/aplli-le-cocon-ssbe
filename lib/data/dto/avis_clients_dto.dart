class AvisClientsDto {
  final String id;
  final String categories;
  final String text;
  final DateTime publishDate;

  AvisClientsDto({
    required this.id,
    required this.categories,
    required this.text,
    required this.publishDate,
  });

  factory AvisClientsDto.fromJson(Map<String, dynamic> json) {
    return AvisClientsDto(
      id: json['id'],
      categories: json['categories'],
      text: json['text'],
      publishDate: DateTime.parse(json['publishDate']), // Assurez-vous que le format est correct
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categories': categories,
      'text': text,
      'publishDate': publishDate.toIso8601String(), // Convertir DateTime en String
    };
  }

  @override
  String toString() {
    return 'AvisClientsDto{id: $id, categories: $categories, text: $text, publishDate: $publishDate}';
  }
}
