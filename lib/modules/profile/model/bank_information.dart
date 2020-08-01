class BankInformation {
  final String mobile;
  final String bankName;
  final String bankCode;
  final String accountNumber;
  final int balance;
  final int totalIncome;
  final int totalWithdrawal;
  BankInformation({
    this.mobile,
    this.bankName,
    this.bankCode,
    this.accountNumber,
    this.balance,
    this.totalIncome,
    this.totalWithdrawal,
  });

  Map<String, dynamic> toMap() {
    return {
      'mobile': mobile,
      'bankName': bankName,
      'bankCode': bankCode,
      'accountNumber': accountNumber,
      'balance': balance,
      'totalIncome': totalIncome,
      'totalWithdrawal': totalWithdrawal,
    };
  }

  factory BankInformation.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return BankInformation(
      mobile: map['mobile'],
      bankName: map['bankName'],
      bankCode: map['bankCode'],
      accountNumber: map['accountNumber'],
      balance: map['balance'],
      totalIncome: map['totalIncome'],
      totalWithdrawal: map['totalWithdrawal'],
    );
  }
}
