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
      pin = '';
    });
    saved.fold((Failure failure) {
      setState(() {
        _loading = false;
      });
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
