import 'package:quickfix/modules/transfer/model/bank_list.dart';

abstract class TransferInterface {
  Future<List<BankList>> getBankList();
  Future<String> getAccountName(String accountNumber, String code);
  Future<bool> transferFund({
    String accountNumber,
    String code,
    String accountName,
    String pin,
    double amount,
    String narration,
    bool isBeneficiary,
  });
}
