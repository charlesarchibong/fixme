class TransactionFailedException implements Exception {
  final String message;
  TransactionFailedException({
    this.message,
  }) : super();
}
