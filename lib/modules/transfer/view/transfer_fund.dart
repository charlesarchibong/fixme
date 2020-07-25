import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickfix/helpers/flush_bar.dart';
import 'package:quickfix/models/failure.dart';
import 'package:quickfix/modules/transfer/model/bank_list.dart';
import 'package:quickfix/modules/transfer/provider/transfer_provider.dart';
import 'package:quickfix/util/const.dart';

class TransferFund extends StatefulWidget {
  @override
  _TransferFundState createState() => _TransferFundState();
}

class _TransferFundState extends State<TransferFund> {
  TextEditingController _accountNumberController = TextEditingController();
  TextEditingController _accountNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  BankList bankSelected;
  bool _loading = false;
  bool _initialLoading = false;

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.lightAccent,
//          automaticallyImplyLeading: false,
//          centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Transfer Fund',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              _initialLoading
                  ? CircularProgressIndicator(
                      backgroundColor: Theme.of(context).accentColor,
                    )
                  : Container(
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
                                    controller: _accountNumberController,
                                    keyboardType: TextInputType.text,
                                    validator: (value) {
                                      return value == ''
                                          ? 'Account Number can not be empty'
                                          : null;
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Enter Account Number',
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Card(
                                elevation: 4.0,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 5.0, right: 5.0),
                                  child: DropdownButton<BankList>(
                                    value: bankSelected,
                                    hint: Text(
                                      'Select Bank ',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    isExpanded: true,
                                    underline: SizedBox(),
                                    icon: Icon(Icons.arrow_downward,
                                        color: Colors.black),
                                    items: bankList.map((BankList v) {
                                      return DropdownMenuItem<BankList>(
                                        value: v,
                                        child: Text(v.name),
                                      );
                                    }).toList(),
                                    onChanged: (BankList newValue) {
                                      setState(() {
                                        bankSelected = newValue;
                                      });
                                    },
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
                                  child: TextFormField(
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
                                        color: Colors.grey,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                            ],
                          )),
                    ),
              SizedBox(
                height: 10,
              ),
              _loading
                  ? CircularProgressIndicator(
                      backgroundColor: Theme.of(context).accentColor)
                  : FlatButton(
                      child: Text("Transfer"),
                      padding: EdgeInsets.all(10.0),
                      textColor: Colors.white,
                      color: Theme.of(context).accentColor,
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            _loading = true;
                          });
                        }
                      },
                    )
            ],
          ),
        ),
      ),
    );
  }
}
