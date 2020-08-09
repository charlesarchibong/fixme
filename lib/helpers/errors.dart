class TransactionFailedException implements Exception {
  final String message;
  TransactionFailedException({
    this.message,
  }) : super();
}

class InvalidPhoneException implements Exception {
  final String message;
  InvalidPhoneException({
    this.message,
  }) : super();
}
