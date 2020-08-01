import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:quickfix/helpers/errors.dart';
import 'package:quickfix/modules/profile/model/user.dart';
import 'package:quickfix/modules/transfer/model/bank_list.dart';
import 'package:quickfix/modules/transfer/service/interface/transfer_interface.dart';
import 'package:quickfix/services/network/network_service.dart';
import 'package:quickfix/util/Utils.dart';
import 'package:quickfix/util/content_type.dart';

class TransferApi extends TransferInterface {
  @override
  Future<List<BankList>> getBankList() async {
    try {
      User currentUser = await Utils.getUserSession();
      String apiKey = await Utils.getApiKey();
      String url = 'https://manager.fixme.ng/g-b-info';
      Map<String, dynamic> body = {
        'mobile': currentUser.phoneNumber,
      };
      body['rated_by'] = currentUser.phoneNumber;
      Map<String, String> headers = {'Authorization': 'Bearer $apiKey'};
      Response response = await NetworkService().post(
        url: url,
        body: {},
        queryParam: body,
        headers: headers,
        contentType: ContentType.JSON,
      );
      if (response.statusCode == 200) {
        List<BankList> bankList = List();
        List responseList = response.data['bankInfo'] as List;
        responseList.forEach(
          (map) {
            bankList.add(
              BankList.fromMap(map),
            );
          },
        );
        return bankList;
      } else {
        throw Exception('Request was not successful, please try again.');
      }
    } catch (e) {
      Logger().e(e.toString());
      rethrow;
    }
  }

  @override
  Future<String> getAccountName(String accountNumber, String code) async {
    try {
      User currentUser = await Utils.getUserSession();
      String apiKey = await Utils.getApiKey();
      String url = 'https://manager.fixme.ng/validate-acount-number';
      Map<String, dynamic> body = {
        'mobile': currentUser.phoneNumber,
        'bankCode': code,
        'accountNumber': accountNumber,
      };
      Map<String, String> headers = {'Authorization': 'Bearer $apiKey'};
      Response response = await NetworkService().post(
        url: url,
        body: {},
        queryParam: body,
        headers: headers,
        contentType: ContentType.JSON,
      );
      if (response.statusCode == 200 && response.data['reqRes'] == 'true') {
        return response.data['account_name'];
      } else {
        throw Exception('Request was not successful, please try again.');
      }
    } catch (e) {
      Logger().e(e.toString());
      rethrow;
    }
  }

  @override
  Future<bool> transferFund(
      {String accountNumber,
      String code,
      String accountName,
      String pin,
      double amount,
      String narration,
      bool isBeneficiary}) async {
    try {
      User currentUser = await Utils.getUserSession();
      String apiKey = await Utils.getApiKey();
      String url = 'https://manager.fixme.ng/initiate-transfer';
      String ranString = Utils.generateId(20);
      String token64 = base64.encode(
        utf8.encode(
          '$ranString:$pin',
        ),
      );
      String token = 'PIN $token64';
      Map<String, dynamic> body = {
        'mobile': currentUser.phoneNumber,
        'bankCode': code,
        'accountNumber': accountNumber,
        'accountName': accountName,
        'secPin': token,
        'naration': narration,
        'isBeneficiary': isBeneficiary,
        'amount': amount,
      };
      Map<String, String> headers = {'Authorization': 'Bearer $apiKey'};
      Response response = await NetworkService().post(
        url: url,
        body: {},
        queryParam: body,
        headers: headers,
        contentType: ContentType.JSON,
      );
      if (response.statusCode == 200 && response.data['reqRes'] == 'true') {
        return true;
      } else if (response.data['reqRes'] == 'false') {
        throw TransactionFailedException(message: response.data['message']);
      } else {
        throw Exception('Request was not successful, please try again.');
      }
    } catch (e) {
      if (e is DioError) {
        Logger().e(e.response.data);
      } else {
        Logger().e(e.toString());
      }
      rethrow;
    }
  }
}
