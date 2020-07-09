import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:quickfix/helpers/flush_bar.dart';
import 'package:quickfix/modules/main_screen/view/main_screen.dart';
import 'package:quickfix/modules/profile/provider/profile_provider.dart';
import 'package:quickfix/util/Utils.dart';

class NoProfileImage extends StatefulWidget {
  NoProfileImage({Key key}) : super(key: key);

  @override
  _NoProfileImageState createState() => _NoProfileImageState();
}

class _NoProfileImageState extends State<NoProfileImage> {
  @override
  void initState() {
    sendUsertoMainScreen();
    super.initState();
  }

  void sendUsertoMainScreen() async {
    final user = await Utils.getUserSession();
    if (user.profilePicture == null || user.profilePicture == '') {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) {
          return MainScreen();
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        body: Center(
          child: Container(
            // height: 400,
            child: Padding(
              padding: const EdgeInsets.all(
                12.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  SvgPicture.asset(
                    'assets/sad.svg',
                    semanticsLabel: 'So Sad',
                    width: 330,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Dear Artisan/Service Provider, please kindly update your profile picture.',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Consumer<ProfileProvider>(
                            builder: (context, profileProvider, child) {
                          return profileProvider.loading
                              ? CircularProgressIndicator()
                              : RaisedButton(
                                  child: Text(
                                    "Click here to update",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  color: Theme.of(context).accentColor,
                                  onPressed: () async {
                                    profileProvider.setLoading();
                                    profileProvider.getImage().then((value) {
                                      FlushBarCustomHelper.showInfoFlushbar(
                                        context,
                                        'Success',
                                        'Profile picture updated',
                                      );
                                      profileProvider.setNotLoading();
                                      Future.delayed(Duration(seconds: 5), () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => MainScreen(),
                                          ),
                                        );
                                      });
                                    }).catchError((e) {
                                      FlushBarCustomHelper.showInfoFlushbar(
                                        context,
                                        'Error',
                                        'Profile picture was not updated, please try again',
                                      );
                                      profileProvider.setNotLoading();
                                    });
                                  },
                                );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
