abstract class AddAvisClientsEvent {}

class AddAvisClientsSignUpEvent extends AddAvisClientsEvent {
  final String id;
  final String categories;
  final String text;
  final DateTime publishDate;
  final Function navigateToAccount;



  AddAvisClientsSignUpEvent({
    required this.id,
    required this.categories,
    required this.text,
    required this.publishDate,
    required this.navigateToAccount,
  });

}
