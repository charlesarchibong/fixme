import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:quickfix/helpers/errors.dart';
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
      bool transfered = await TransferApi().transferFund(
        accountName: accountName,
        accountNumber: accountName,
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
          message: 'An error occured, please try again',
        ),
      );
    }
  }
}
