import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lock_screen/flutter_lock_screen.dart';
import 'package:local_auth/local_auth.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

import '../../../helpers/flush_bar.dart';
import '../../../models/failure.dart';
import '../../../util/Utils.dart';
import '../../../util/const.dart';
import '../model/bank_list.dart';
import '../provider/transfer_provider.dart';

class TransferFund extends StatefulWidget {
  @override
  _TransferFundState createState() => _TransferFundState();
}

class _TransferFundState extends State<TransferFund> {
  TextEditingController _accountNumberController = TextEditingController();
  TextEditingController _accountNameController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  BankList bankSelected;
  bool _loading = false;
  bool _initialLoading = false;
  bool isFingerprint = false;

  String pin = '';
  String accountNumber;

  Future getUserPhone() async {
    final user = await Utils.getUserSession();
    setState(() {
      accountNumber = user.accountNumber;
    });
  }

  List<BankList> bankList = List();

  getBankList() async {
    setState(() {
      _initialLoading = true;
    });
    final transferProvider = Provider.of<TransferProvider>(
      context,
      listen: false,
    );
    final fetched = await transferProvider.fetchBanks();
    fetched.fold(
      (Failure failure) {
        setState(() {
          _initialLoading = false;
        });
        FlushBarCustomHelper.showErrorFlushbar(
          context,
          'Error',
          failure.message,
        );
      },
      (List<BankList> list) {
        setState(() {
          bankList = list;
          _initialLoading = false;
        });
      },
    );
  }

  @override
  void initState() {
    getBankList();
    getUserPhone();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Constants.lightAccent,
//          automaticallyImplyLeading: false,
//          centerTitle: true,
        iconTheme: IconThemeData(color: Color(0xfffefefef)),
        title: Text(
          'Transfer Fund',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: _initialLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Column(
                          children: <Widget>[
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Color(0xffE4E4E4),
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.black),
                              ),
                              child: SearchableDropdown.single(
                                items: bankList.map((BankList v) {
                                  return DropdownMenuItem<BankList>(
                                    value: v,
                                    child: Text(v.name),
                                  );
                                }).toList(),
                                style: TextStyle(color: Colors.black),
                                value: bankSelected,
                                hint: "Select Bank",
                                searchHint: "Search Bank",
                                onChanged: (value) {
                                  Logger().i(value);
                                  setState(() {
                                    bankSelected = value;
                                  });
                                  if (_accountNumberController.text.length ==
                                      10) {
                                    _verifyAccountNumber(
                                      _accountNumberController.text,
                                      bankSelected.code,
                                    );
                                  }
                                },
                                isExpanded: true,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Color(0xffE4E4E4),
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.black),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 10),
                              child: TextFormField(
                                controller: _accountNumberController,
                                keyboardType: TextInputType.phone,
                                style: TextStyle(color: Colors.black),
                                // maxLength: 10,
                                enabled: _loading == true ? false : true,
                                validator: (value) {
                                  return value == ''
                                      ? 'Account Number can not be empty'
                                      : null;
                                },
                                decoration: InputDecoration(
                                  hintText: 'Enter Account Number',
                                  hintStyle: TextStyle(
                                    color: Colors.black,
                                  ),
                                  border: InputBorder.none,
                                ),
                                onChanged: (value) {
                                  if (value.length == 10) {
                                    if (bankSelected == null) {
                                      FlushBarCustomHelper.showErrorFlushbar(
                                        context,
                                        'Error',
                                        'Please select reciever bank',
                                      );
                                      return;
                                    }
                                    _verifyAccountNumber(
                                      _accountNumberController.text,
                                      bankSelected.code,
                                    );
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Color(0xffE4E4E4),
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.black),
                              ),
                              padding: const EdgeInsets.only(
                                left: 10.0,
                                right: 10.0,
                              ),
                              child: TextFormField(
                                readOnly: true,
                                style: TextStyle(color: Colors.black),
                                controller: _accountNameController,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  return value == ''
                                      ? 'Account Name can not be empty'
                                      : null;
                                },
                                decoration: InputDecoration(
                                  hintText: 'Confirm Account Name',
                                  hintStyle: TextStyle(
                                    color: Colors.black,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Color(0xffE4E4E4),
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.black),
                              ),
                              padding: const EdgeInsets.only(
                                left: 10.0,
                                right: 10.0,
                              ),
                              child: TextFormField(
                                enabled: _loading == true ? false : true,
                                controller: _amountController,
                                style: TextStyle(color: Colors.black),
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  try {
                                    int.parse(value);
                                    return value == ''
                                        ? 'Amount can not be empty'
                                        : null;
                                  } catch (e) {
                                    return 'Amount should contain only numbers';
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: 'Amount',
                                  hintStyle: TextStyle(
                                    color: Colors.black,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Color(0xffE4E4E4),
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.black),
                              ),
                              padding: const EdgeInsets.only(
                                left: 10.0,
                                right: 10.0,
                              ),
                              child: TextFormField(
                                maxLines: 5,
                                style: TextStyle(color: Colors.black),
                                enabled: _loading == true ? false : true,
                                controller: _descriptionController,
                                keyboardType: TextInputType.multiline,
                                decoration: InputDecoration(
                                  hintText: 'Transaction Description',
                                  hintStyle: TextStyle(
                                    color: Colors.black,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            InkWell(
                              onTap: () async {
                                if (_formKey.currentState.validate()) {
                                  _authTransfer();
                                }
                              },
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Theme.of(context).accentColor,
                                ),
                                child: Center(
                                  child: _loading
                                      ? CircularProgressIndicator()
                                      : Text(
                                          "Transfer Fund",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _authTransfer() async {
    _showBottomSheet();
    // try {
    //   var localAuth = LocalAuthentication();
    //   // localAuth.
    //   bool didAuthenticate = await localAuth.authenticateWithBiometrics(
    //     localizedReason: 'Please authenticate to complete transaction',
    //     useErrorDialogs: true,
    //     stickyAuth: true,
    //     sensitiveTransaction: true,
    //   );
    //   print('auth is $didAuthenticate');
    // } catch (e) {
    //   Logger().e(
    //     e.toString(),
    //   );
    //   FlushBarCustomHelper.showErrorFlushbar(
    //     context,
    //     'Error',
    //     'Unable to complete transaction, please try again',
    //   );
    // }
  }

  Future<Null> biometrics() async {
    final LocalAuthentication auth = new LocalAuthentication();
    bool authenticated = false;

    try {
      authenticated = await auth.authenticateWithBiometrics(
        localizedReason: 'Scan your fingerprint to authenticate',
        useErrorDialogs: true,
        stickyAuth: true,
      );
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;
    if (authenticated) {
      setState(() {
        isFingerprint = true;
      });
    }
  }

  _showBottomSheet() {
    _scaffoldKey.currentState.showBottomSheet((context) {
      return LockScreen(
        title: "Enter your security pin",
        passLength: 4,
        bgImage: "assets/pin.png",
        fingerPrintImage: "assets/fingerprint.png",
        showFingerPass: true,
        fingerFunction: biometrics,
        fingerVerify: isFingerprint,
        borderColor: Colors.white,
        showWrongPassDialog: true,
        wrongPassContent: "Wrong security pin, please try again.",
        wrongPassTitle: "Opps!",
        wrongPassCancelButtonText: "Cancel",
        passCodeVerify: (passcode) async {
          Logger().i(String.fromCharCodes(passcode));
          if (passcode.length == 4) {
            for (int i = 0; i < 4; i++) {
              setState(() {
                pin += passcode[i].toString();
              });
            }
            print('fjkdncjkndje ');

            return true;
          }

          return false;
        },
        onSuccess: () {
          // Navigator.of(context).pushReplacement(
          //     new MaterialPageRoute(builder: (BuildContext context) {
          //   return EmptyPage();
          // }));
          print('Success');
          Logger().i(
            'Pin was successfully entered and the pin is = $pin',
          );
          transferFund();
        },
      );
    });
  }

  void _verifyAccountNumber(String accountNumber, String code) async {
    setState(() {
      _loading = true;
    });
    final transferProvider = Provider.of<TransferProvider>(
      context,
      listen: false,
    );
    final fetched = await transferProvider.getAccountName(
      code,
      accountNumber,
    );
    fetched.fold((Failure failure) {
      FlushBarCustomHelper.showErrorFlushbar(
        context,
        'Error',
        failure.message,
      );
      setState(() {
        _loading = false;
      });
    }, (String accounName) {
      setState(() {
        _accountNameController.text = accounName;
        _loading = false;
      });
    });
  }

  void transferFund() async {
    String accountNumber = _accountNumberController.text;
    String accountName = _accountNameController.text;
    String narration = _descriptionController.text;
    double amount = double.parse(_amountController.text);
    String code = bankSelected.code;
    bool isBeneficiary = false;

    Navigator.pop(context);
    setState(() {
      _loading = true;
    });
    final transferProvider = Provider.of<TransferProvider>(
      context,
      listen: false,
    );
    final transfered = await transferProvider.tranfersFund(
      accountName: accountName,
      accountNumber: accountNumber,
      amount: amount,
      code: code,
      isBeneficiary: isBeneficiary,
      narration: narration,
      pin: pin,
    );

    setState(() {
      pin = '';
      _loading = false;
    });
    transfered.fold((Failure failure) {
      FlushBarCustomHelper.showErrorFlushbar(
        context,
        'Error',
        failure.message,
      );
    }, (bool success) {
      FlushBarCustomHelper.showInfoFlushbar(
        context,
        'Success',
        'Your Transaction was successful.',
      );
    });
  }
}

// Card(
//                               elevation: 4.0,
//                               child: Padding(
//                                 padding: const EdgeInsets.only(
//                                   left: 10.0,
//                                   right: 10.0,
//                                 ),
//     child: SearchableDropdown.single(
//       items: bankList.map((BankList v) {
//         return DropdownMenuItem<BankList>(
//           value: v,
//           child: Text(v.name),
//         );
//       }).toList(),
//       value: bankSelected,
//       hint: "Select Bank",
//       searchHint: "Search Bank",
//       onChanged: (value) {
//         Logger().i(value);
//         setState(() {
//           bankSelected = value;
//         });
//         if (_accountNumberController.text.length ==
//             10) {
//           _verifyAccountNumber(
//             _accountNumberController.text,
//             bankSelected.code,
//           );
//         }
//       },
//       isExpanded: true,
//     ),
//   ),
// ),
//                             SizedBox(
//                               height: 20,
//                             ),
// Card(
//   elevation: 4.0,
//   child: Padding(
//     padding: const EdgeInsets.only(
//       left: 10.0,
//       right: 10.0,
//     ),
//     child: TextFormField(
//       controller: _accountNumberController,
//       keyboardType: TextInputType.phone,
//       maxLength: 10,
//       enabled: _loading == true ? false : true,
//       validator: (value) {
//         return value == ''
//             ? 'Account Number can not be empty'
//             : null;
//       },
//       decoration: InputDecoration(
//         hintText: 'Enter Account Number',
//         hintStyle: TextStyle(
//           color: Colors.grey,
//         ),
//         border: InputBorder.none,
//       ),
//       onChanged: (value) {
//         if (value.length == 10) {
//           if (bankSelected == null) {
//             FlushBarCustomHelper.showErrorFlushbar(
//               context,
//               'Error',
//               'Please select reciever bank',
//             );
//             return;
//           }
//           _verifyAccountNumber(
//             _accountNumberController.text,
//             bankSelected.code,
//           );
//         }
//       },
//     ),
//   ),
// ),
//                             SizedBox(
//                               height: 20,
//                             ),
// Card(
//   elevation: 4.0,
//   child: Padding(
//     padding: const EdgeInsets.only(
//       left: 10.0,
//       right: 10.0,
//     ),
//     child: TextFormField(
//       readOnly: true,
//       controller: _accountNameController,
//       keyboardType: TextInputType.text,
//       validator: (value) {
//         return value == ''
//             ? 'Account Name can not be empty'
//             : null;
//       },
//       decoration: InputDecoration(
//         hintText: 'Confirm Account Name',
//         hintStyle: TextStyle(
//           color: Colors.grey,
//         ),
//         border: InputBorder.none,
//       ),
//     ),
//   ),
// ),
//                             SizedBox(
//                               height: 20,
//                             ),
//                             Card(
//                               elevation: 4.0,
//                               child: Padding(
//                                 padding: const EdgeInsets.only(
//                                   left: 10.0,
//                                   right: 10.0,
//                                 ),
//                                 child: TextFormField(
//                                   enabled: _loading == true ? false : true,
//                                   controller: _amountController,
//                                   keyboardType: TextInputType.phone,
//                                   validator: (value) {
//                                     try {
//                                       int.parse(value);
//                                       return value == ''
//                                           ? 'Amount can not be empty'
//                                           : null;
//                                     } catch (e) {
//                                       return 'Amount should contain only numbers';
//                                     }
//                                   },
//                                   decoration: InputDecoration(
//                                     hintText: 'Amount',
//                                     hintStyle: TextStyle(
//                                       color: Colors.grey,
//                                     ),
//                                     border: InputBorder.none,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(
//                               height: 20,
//                             ),
// Card(
//   elevation: 4.0,
//   child: Padding(
//     padding: const EdgeInsets.only(
//       left: 10.0,
//       right: 10.0,
//     ),
//     child: TextFormField(
//       maxLines: 10,
//       enabled: _loading == true ? false : true,
//       controller: _descriptionController,
//       keyboardType: TextInputType.multiline,
//       decoration: InputDecoration(
//         hintText: 'Transaction Description',
//         hintStyle: TextStyle(
//           color: Colors.grey,
//         ),
//         border: InputBorder.none,
//       ),
//     ),
//   ),
// ),
