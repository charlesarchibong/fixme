import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:quickfix/modules/auth/view/login.dart';
import 'package:quickfix/util/const.dart';

class Walkthrough extends StatefulWidget {
  @override
  _WalkthroughState createState() => _WalkthroughState();
}

class _WalkthroughState extends State<Walkthrough> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    FlutterStatusbarcolor.setNavigationBarWhiteForeground(true);
    FlutterStatusbarcolor.setStatusBarColor(Colors.red);
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.red);
    FlutterStatusbarcolor.setNavigationBarColor(Constants.darkAccent);

    List<PageViewModel> pages = [
      PageViewModel(
        // title: "Get Technicain",
        title: "Find the Right Fix Quickly",
        body:
            "We are the simplest, safest and fastest way to hire service providers.",
        image: Image.asset(
          "assets/on1.png",
          height: 100.0,
        ),
        decoration: PageDecoration(
          titleTextStyle: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).accentColor,
          ),
          bodyTextStyle: TextStyle(fontSize: 15.0),
//          dotsDecorator: DotsDecorator(
//            activeColor: Theme.of(context).accentColor,
//            activeSize: Size.fromRadius(8),
//          ),
          pageColor: Theme.of(context).primaryColor,
        ),
      ),
      PageViewModel(
        title: "Easy and Secure Payment",
        body: "The fastest and safest way to pay " +
            "for service delivery nationwide.",
        image: Image.asset(
          "assets/on2.png",
          height: 100.0,
        ),
        decoration: PageDecoration(
          titleTextStyle: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).accentColor,
          ),
          bodyTextStyle: TextStyle(fontSize: 15.0),
//          dotsDecorator: DotsDecorator(
//            activeColor: Theme.of(context).accentColor,
//            activeSize: Size.fromRadius(8),
//          ),
          pageColor: Theme.of(context).primaryColor,
        ),
      ),
      // PageViewModel(
      //   "Easy Payment",
      //   "Vivamus magna justo, lacinia eget consectetur sed, convallis at tellus."
      //       " Vestibulum ac diam sit amet quam vehicula elementum sed sit amet "
      //       "dui. Nulla porttitor accumsan tincidunt.",
      //   image: Image.asset(
      //     "assets/on3.png",
      //     height: 175.0,
      //   ),
      //   decoration: PageDecoration(
      //     titleTextStyle: TextStyle(
      //       fontSize: 28.0,
      //       fontWeight: FontWeight.w600,
      //       color: Theme.of(context).accentColor,
      //     ),
      //     bodyTextStyle: TextStyle(fontSize: 15.0),
      //     dotsDecorator: DotsDecorator(
      //       activeColor: Theme.of(context).accentColor,
      //       activeSize: Size.fromRadius(8),
      //     ),
      //     pageColor: Theme.of(context).primaryColor,
      //   ),
      // ),
    ];

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Padding(
          padding: EdgeInsets.only(top: 100.0),
          child: IntroductionScreen(
            pages: pages,
            dotsDecorator: DotsDecorator(
              activeColor: Theme.of(context).accentColor,
              activeSize: Size.fromRadius(8),
            ),
            onDone: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return LoginScreen();
                  },
                ),
              );
            },
            onSkip: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return LoginScreen();
                  },
                ),
              );
            },
            showSkipButton: true,
            skip: Text("Skip"),
            next: Text(
              "Next",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Theme.of(context).accentColor,
              ),
            ),
            done: Text(
              "Done",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
