import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

import '../../../helpers/errors.dart';
import '../../../models/failure.dart';
import '../model/bank_list.dart';
import '../service/transfer_api.dart';

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

  Future<Either<Failure, String>> getAccountName(
      String code, String accountNumber) async {
    try {
      String accountName = await TransferApi().getAccountName(
        accountNumber,
        code,
      );
      return right(accountName);
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

  Future<Either<Failure, bool>> tranfersFund(
      {String accountNumber,
      String code,
      String accountName,
      String pin,
      double amount,
      String narration,
      bool isBeneficiary}) async {
    try {
      // Logger().i(a)
      bool transfered = await TransferApi().transferFund(
        accountName: accountName,
        accountNumber: accountNumber,
        amount: amount,
        code: code,
        isBeneficiary: isBeneficiary,
        narration: narration,
        pin: pin,
      );
      return right(transfered);
    } catch (e) {
      Logger().e(
        e.toString(),
      );
      if (e is TransactionFailedException) {
        return left(
          Failure(
            message: '${e.message}',
          ),
        );
      }

      return left(
        Failure(
          message:
              'An error occured while trying to transfer fund from your Fixme account, please try again',
        ),
      );
    }
  }
}
