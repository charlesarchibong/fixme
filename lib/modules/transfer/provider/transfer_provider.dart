import 'package:flutter/cupertino.dart';
import 'package:quickfix/modules/transfer/model/bank_list.dart';

class TransferProvider with ChangeNotifier {
  List<BankList> _bankList = List();
  List<BankList> get bankList => _bankList;
}
