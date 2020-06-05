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

showBankEditPopUp(
    {BuildContext context,
    GlobalKey<ScaffoldState> profileScaffoldKey,
    String accountNumber}) {
  final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
  final _formKey = GlobalKey<FormState>();
  TextEditingController _accountNumberController =
      TextEditingController(text: accountNumber);
}
