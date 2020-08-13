import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lock_screen/flutter_lock_screen.dart';
import 'package:local_auth/local_auth.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:quickfix/util/Utils.dart';

import '../../../helpers/flush_bar.dart';
import '../../../models/failure.dart';
import '../../main_screen/view/main_screen.dart';
import '../provider/security_pin_provider.dart';

class EnterSecurityPin extends StatefulWidget {
  EnterSecurityPin({Key key}) : super(key: key);

  @override
  _EnterSecurityPinState createState() => _EnterSecurityPinState();
}

class _EnterSecurityPinState extends State<EnterSecurityPin> {
  bool _loading = false;
  final _securityPinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isFingerprint = false;

  String pin = '';
  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        body: Center(
          child: _loading
              ? CircularProgressIndicator()
              : Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: LockScreen(
                    title: "Enter a security pin for transaction",
                    passLength: 4,
                    bgImage: "assets/pin.png",
                    fingerPrintImage: "assets/fingerprint.png",
                    showFingerPass: false,
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
                      // transferFund();
                      _savedSecurityPin();
                    },
                  ),
                ),
        ),

        // Center(
        //   child: Container(
        //     // height: 400,
        //     child: Padding(
        //       padding: const EdgeInsets.all(
        //         12.0,
        //       ),
        //       child: Column(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         crossAxisAlignment: CrossAxisAlignment.center,
        //         children: [
        //           SizedBox(
        //             height: 15,
        //           ),
        //           Padding(
        //             padding: const EdgeInsets.only(
        //               left: 20,
        //               right: 20,
        //             ),
        //             child: Column(
        //               children: <Widget>[
        //                 Image.asset(
        //                   'assets/logo.png',
        //                   width: 250,
        //                 ),
        //                 SizedBox(
        //                   height: 50,
        //                 ),
        //                 Text(
        //                   'Kindly enter a four (4) digit security pin to secure your account and transaction.',
        //                   style: TextStyle(
        //                     fontWeight: FontWeight.bold,
        //                     fontSize: 20.0,
        //                   ),
        //                   textAlign: TextAlign.center,
        //                 ),
        //                 SizedBox(
        //                   height: 20,
        //                 ),
        //                 _securityPin(),
        //                 SizedBox(
        //                   height: 20,
        //                 ),
        //                 _loading
        //                     ? CircularProgressIndicator()
        //                     : RaisedButton(
        //                         child: Text(
        //                           "Click here to update",
        //                           style: TextStyle(
        //                             color: Colors.white,
        //                           ),
        //                         ),
        //                         color: Theme.of(context).accentColor,
        //                         onPressed: () async {
        //                           _savedSecurityPin(
        //                             _securityPinController.text,
        //                           );
        //                         },
        //                       ),
        //               ],
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
      ),
    );
  }

  Widget _securityPin() {
    return Card(
      elevation: 3.0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        child: Form(
          key: _formKey,
          child: TextFormField(
            autofocus: true,
            focusNode: FocusNode(
              canRequestFocus: true,
            ),
            validator: (value) {
              try {
                if (value.isEmpty) {
                  return 'Please enter a security pin';
                }
                if (value.length != 4) {
                  return 'Security pin should be four (4) digit';
                }
                int.parse(value);
                return null;
              } catch (e) {
                Logger().e(e.toString());
                return 'Security pin can only contain 6 digit numbers';
              }
            },
            keyboardType: TextInputType.phone,
            textCapitalization: TextCapitalization.none,
            style: TextStyle(
              fontSize: 15.0,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),
              hintText: "Enter 4 Digit Pin",
              hintStyle: TextStyle(
                fontSize: 15.0,
                color: Colors.grey,
              ),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.grey,
              ),
            ),
            maxLength: 4,
            maxLines: 1,
            controller: _securityPinController,
          ),
        ),
      ),
    );
  }

  void _savedSecurityPin() async {
    setState(() {
      _loading = true;
    });
    final securityPinProvider = Provider.of<SecurityPinProvider>(
      context,
      listen: false,
    );
    final saved = await securityPinProvider.savedSecurityPin(pin);
    setState(() {
      _loading = false;

      pin = '';
    });
    saved.fold((Failure failure) {
      FlushBarCustomHelper.showErrorFlushbar(
        context,
        'Error',
        failure.message,
      );
    }, (bool save) {
      Utils.setSecurityPinExist(true);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => MainScreen(),
        ),
      );
    });
  }
}
