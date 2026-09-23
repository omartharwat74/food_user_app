class CreateTicketRequest {
  final String subject;
  final String message;

  const CreateTicketRequest({required this.subject, required this.message});

  Map<String, dynamic> toJson() {
    return {'subject': subject, 'message': message};
  }
}
