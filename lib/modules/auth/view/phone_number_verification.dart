import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../helpers/flush_bar.dart';
import '../../../util/Utils.dart';
import '../../../util/const.dart';
import '../../main_screen/view/main_screen.dart';
import '../../main_screen/view/no_profile_image.dart';
import '../../profile/model/user.dart' as fixmeUser;
import 'login.dart';
import 'security_pin.dart';
import 'signup.dart';

class PhoneNumberVerification extends StatefulWidget {
  final fixmeUser.User user;
  final String phone;

  const PhoneNumberVerification({Key key, this.user, @required this.phone})
      : super(key: key);
  @override
  _PhoneNumberVerificationState createState() =>
      _PhoneNumberVerificationState();
}

class _PhoneNumberVerificationState extends State<PhoneNumberVerification> {
  bool _loading = false;

  var onTapRecognizer;
  bool hasError = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  TextEditingController textEditingController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  // ignore: close_sinks
  StreamController<ErrorAnimationType> errorController;
  @override
  void initState() {
    _loading = false;
    timeOutNumber = 60;

    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };
    timer = new Timer.periodic(new Duration(seconds: 1), (time) {
      setState(() {
        if (timeOutNumber != 0) {
          timeOutNumber--;
        } else {
          timer.cancel();
          FlushBarCustomHelper.showErrorFlushbar(
            context,
            'Error',
            'Phone number verification timeout',
          );
          Future.delayed(
            Duration(
              seconds: 7,
            ),
            () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => LoginScreen(),
                ),
              );
            },
          );
        }
      });
    });
    errorController = StreamController<ErrorAnimationType>();
    _sendCodeToPhoneNumber();
    super.initState();
  }

  @override
  void dispose() {
    errorController.close();
    timer.cancel();
    textEditingController.dispose();
    timeOutNumber = 60;
    _loading = false;
    super.dispose();
  }

  String verificationId;

  int timeOutNumber = 60;

  Timer timer;

  Future<void> _sendCodeToPhoneNumber() async {
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential authUser) {
      setState(() {
        print('phone number verifieds');

        FlushBarCustomHelper.showInfoFlushbar(
          context,
          'Success',
          '${widget.phone} has been verified',
        );
        phoneSuccesRequest();
      });
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      FlushBarCustomHelper.showErrorFlushbar(
        context,
        'Error',
        authException.message,
      );
      timer.cancel();
      Future.delayed(
        Duration(
          seconds: 7,
        ),
        () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => LoginScreen(),
            ),
          );
        },
      );
      // loginForm.setNotLoading();
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      setState(() {
        this.verificationId = verificationId;
      });
      print(forceResendingToken);
      FlushBarCustomHelper.showInfoFlushbar(
        context,
        'Success',
        'Your automatic verification code has been sent to ${widget.phone}',
      );
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      this.verificationId = verificationId;
      print('auto retrieve failed');
      // FlushBarCustomHelper.showErrorFlushbar(
      //   context,
      //   'Error',
      //   'Phone number verification timeout',
      // );
      // Future.delayed(
      //   Duration(
      //     seconds: 7,
      //   ),
      //   () {
      //     Navigator.of(context).push(
      //       MaterialPageRoute(
      //         builder: (_) => Register(
      //           password: widget.password,
      //           user: widget.user,
      //         ),
      //       ),
      //     );
      //   },
      // );
      // loginForm.setNotLoading();
    };

    await auth.verifyPhoneNumber(
      phoneNumber: '${widget.phone}',
      timeout: const Duration(seconds: 40),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  void phoneSuccesRequest() async {
    print('User from phone verification');
    timer.cancel();
    if (widget.user != null) {
      print(widget.user.toJson().toString());
      Utils.setUserSession(json.encode(widget.user));
      Utils.setProfilePicture(widget.user.profilePicture);
      bool exist = await Utils.getSecurityPinExist();
      final picture = widget.user.profilePicture;
      final profile = await Utils.getProfilePicture();
      if (!exist) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) {
            return EnterSecurityPin();
          }),
        );
      } else {
        if (picture != '${Constants.uploadUrl}no_picture_upload' ||
            profile == "don’t ask me for this again") {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) {
              return MainScreen();
            }),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) {
              return NoProfileImage();
            }),
          );
        }
      }
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) {
          return SignupView();
        }),
      );
    }
  }

  void verifyPhoneManually(String verficationId, String smsCode) async {
    AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    await auth.signInWithCredential(credential).then(( result) {
      FlushBarCustomHelper.showInfoFlushbar(
        context,
        'Success',
        '${widget.phone} has been verified',
      );
      phoneSuccesRequest();
    }).catchError((e) {
      print(e.toString());
      FlushBarCustomHelper.showErrorFlushbar(
        context,
        'Error',
        'Phone number verification failed',
      );
      Future.delayed(
        Duration(
          seconds: 7,
        ),
        () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => LoginScreen(),
            ),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            ClipPath(
              clipper: OvalBottomBorderClipper(),
              child: Container(
                height: 200,
                color: Theme.of(context).accentColor,
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: 80,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Text(
                    //   '',
                    //   style: TextStyle(
                    //     fontSize: 30,
                    //     color: Colors.white,
                    //   ),
                    //   textAlign: TextAlign.center,
                    // ),
                    // SizedBox(
                    //   height: 9,
                    // ),
                    GestureDetector(
                      onTap: () {
                        FocusScope.of(context).requestFocus(
                          FocusNode(),
                        );
                      },
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: Container(
                          decoration: BoxDecoration(),
                          height: MediaQuery.of(context).size.height / 1.2,
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            child: Form(
                              key: formKey,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(
                                      'assets/phone_verification.png',
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      'Phone Number Verification',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Theme.of(context).accentColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        text: 'Enter the code sent to ',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: '${widget.phone}',
                                            style: TextStyle(
                                              color:
                                                  Theme.of(context).accentColor,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 9,
                                    ),
                                    _loading
                                        ? Container(
                                            height: 50,
                                            width: 50,
                                            child: CircularProgressIndicator(
                                              backgroundColor:
                                                  Theme.of(context).accentColor,
                                            ),
                                          )
                                        : Container(
                                            height: 50,
                                            child: PinCodeTextField(
                                              length: 6,
                                              obscureText: true,
                                              animationType: AnimationType.fade,
                                              pinTheme: PinTheme(
                                                shape: PinCodeFieldShape.box,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  10,
                                                ),
                                                fieldHeight: 50,
                                                fieldWidth: 40,
                                                activeFillColor: Colors.green,
                                                activeColor: Colors.green,
                                                selectedColor:
                                                    Colors.lightBlue[50],
                                                inactiveColor: Colors.red,
                                                selectedFillColor:
                                                    Colors.transparent,
                                                disabledColor:
                                                    Colors.transparent,
                                                inactiveFillColor:
                                                    Colors.transparent,
                                              ),
                                              animationDuration: Duration(
                                                milliseconds: 300,
                                              ),
                                              backgroundColor:
                                                  Colors.transparent,
                                              enableActiveFill: true,
                                              errorAnimationController:
                                                  errorController,
                                              controller: textEditingController,

                                              // autoValidate: ,
                                              onCompleted: (v) {
                                                print("Completed " + v);
                                                verifyPhoneManually(
                                                  verificationId,
                                                  v,
                                                );
                                              },
                                              textStyle: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              onChanged: (value) {
                                                print(value);
                                                setState(() {
                                                  currentText = value;
                                                });
                                              },
                                              beforeTextPaste: (text) {
                                                print(
                                                    "Allowing to paste $text");
                                                //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                                //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                                return true;
                                              }, appContext: context,
                                            ),
                                          ),
                                    SizedBox(
                                      height: 25,
                                    ),
                                    _loading
                                        ? Container(
                                            height: 50,
                                            width: 50,
                                          )
                                        : RichText(
                                            textAlign: TextAlign.center,
                                            text: TextSpan(
                                              text:
                                                  'Phone verification timeout in: ',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 15,
                                              ),
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text:
                                                      '${timeOutNumber.toString()}',
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                  ],
                                ),
                              ),
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
    );
  }
}
