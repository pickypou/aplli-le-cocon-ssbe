
class Evenements {
  final String id;
  final String categories;
  final DateTime publishDate;
  final String text;

  Evenements({
    required this.id,
    required this.categories,
    required this.publishDate,
    required this.text
});

  factory Evenements.fromMp(Map<String, dynamic> data, String id) {
    return Evenements(
        id: id,
        categories: data['categories'] ?? '',
        publishDate:data['publishDate'] ?? '',
        text:data['text'] ?? '',
    );
  }
}