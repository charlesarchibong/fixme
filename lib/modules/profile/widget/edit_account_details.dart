import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:provider/provider.dart';
import 'package:quickfix/modules/profile/model/bank_code.dart';
import 'package:quickfix/modules/profile/provider/profile_provider.dart';

class EditBankInfoPopUp extends StatefulWidget {
  @override
  _EditBankInfoPopUpState createState() => _EditBankInfoPopUpState();
}

class _EditBankInfoPopUpState extends State<EditBankInfoPopUp> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

BankCode bankCode;
List<BankCode> bankList;
showBankEditPopUp(
    {BuildContext context,
    GlobalKey<ScaffoldState> profileScaffoldKey,
    String accountNumber}) {
  final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
  final _formKey = GlobalKey<FormState>();
  TextEditingController _accountNumberController =
      TextEditingController(text: accountNumber);
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder(
          future: profileProvider.getBankCodes(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            return snapshot.hasData
                ? Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20.0)), //this right here
                    child: Container(
                      height: 300,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 9,
                                right: 9,
                              ),
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
                                        child: Column(
                                          children: <Widget>[
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Card(
                                              elevation: 4.0,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5.0, right: 5.0),
                                                child: TextFormField(
                                                  controller:
                                                      _accountNumberController,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  validator: (value) {
                                                    return value == ''
                                                        ? 'Account Number can not be empty'
                                                        : null;
                                                  },
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        'Enter Account Number',
                                                    hintStyle: TextStyle(
                                                      color: Colors.grey,
                                                    ),
                                                    border: InputBorder.none,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Card(
                                              elevation: 4.0,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5.0, right: 5.0),
                                                child: DropdownButton<BankCode>(
                                                  value: bankCode,
                                                  hint: Text(
                                                    'Select Job Category',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  isExpanded: true,
                                                  underline: SizedBox(),
                                                  icon: Icon(
                                                      Icons.arrow_downward,
                                                      color: Colors.black),
                                                  items: snapshot.data
                                                      .map((BankCode value) {
                                                    return DropdownMenuItem<
                                                        BankCode>(
                                                      value: value,
                                                      child: Text(value.name),
                                                    );
                                                  }).toList(),
                                                  onChanged:
                                                      (BankCode newValue) {
                                                    bankCode = newValue;
                                                    print(bankCode.name);
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  FlatButton(
                                    child: profileProvider.loading
                                        ? Container(
                                            alignment: Alignment.center,
                                            width: 50,
                                            height: 50,
                                            child: CircularProgressIndicator(
                                              backgroundColor: Colors.white,
                                            ),
                                          )
                                        : Text("Save"),
                                    padding: EdgeInsets.all(10.0),
                                    textColor: Colors.white,
                                    color: Theme.of(context).accentColor,
                                    onPressed: () async {
                                      if (_formKey.currentState.validate()) {
                                        // profileProvider.setLoading();
                                        // profileProvider
                                        //     .addSubCategory(input)
                                        //     .then((value) {
                                        //   profileProvider.setNotLoading();
                                        // await profileProvider.updateProfile(
                                        //     firstName, lastName);
                                        Navigator.of(context).pop();
                                        profileScaffoldKey.currentState
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              'Account Details was updated'),
                                          duration: Duration(seconds: 5),
                                        ));
                                        // }).catchError((e) {
                                        //   print(e);
                                        //   profileProvider.setNotLoading();
                                        //   Navigator.of(context).pop();
                                        //   profileScaffoldKey.currentState
                                        //       .showSnackBar(SnackBar(
                                        //     content: Text(
                                        //       e.toString().split(':')[1],
                                        //       style: TextStyle(
                                        //         color: Colors.red,
                                        //       ),
                                        //     ),
                                        //     duration: Duration(seconds: 5),
                                        //   ));
                                        // });
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Column(
                    children: <Widget>[
                      TextShimmer(),
                      SizedBox(
                        height: 10,
                      ),
                      TextShimmer(),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  );
          },
        );
      });
}
