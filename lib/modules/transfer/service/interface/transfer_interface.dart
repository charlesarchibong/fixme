import 'package:quickfix/modules/transfer/model/bank_list.dart';

abstract class TransferInterface {
  Future<List<BankList>> getBankList();
}