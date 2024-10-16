abstract class EvenementEvent {}

class EvenementSignUpEvent extends EvenementEvent {
  final String id;
  final String categories;
  final DateTime publishDate;
  final String title;
  final String pdf;

  EvenementSignUpEvent({
  required this.id,
  required this.categories,
  required this.publishDate,
  required this.title,
  required this.pdf,
});

}