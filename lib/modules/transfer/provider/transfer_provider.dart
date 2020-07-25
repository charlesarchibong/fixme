import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:quickfix/models/failure.dart';
import 'package:quickfix/modules/transfer/model/bank_list.dart';
import 'package:quickfix/modules/transfer/service/transfer_api.dart';

class TransferProvider with ChangeNotifier {
  List<BankList> _bankList = List();
  List<BankList> get bankList => _bankList;

  Future<Either<Failure, List<BankList>>> fetchBanks() async {
    try {
      List<BankList> bankList = await TransferApi().getBankList();
      return right(bankList);
    } catch (e) {
      Logger().e(
        e.toString(),
      );
      return left(
        Failure(
          message: 'An error occured, please try again',
        ),
      );
    }
  }
}
