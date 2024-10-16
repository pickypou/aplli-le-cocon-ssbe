
class Evenements {
  final String id;
  final String categories;
  final DateTime publishDate;
  final String title;
  final String pdf;

  Evenements({
    required this.id,
    required this.categories,
    required this.publishDate,
    required this.title,
    required this.pdf
});

  factory Evenements.fromMp(Map<String, dynamic> data, String id) {
    return Evenements(
        id: id,
        categories: data['categories'] ?? '',
        publishDate:data['publishDate'] ?? '',
        title:data['title'] ?? '',
        pdf:data['pdf'] ?? ''
    );
  }
}