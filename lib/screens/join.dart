import 'package:quickfix/screens/login.dart';
import 'package:quickfix/screens/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JoinApp extends StatefulWidget {
  @override
  _JoinAppState createState() => _JoinAppState();
}

class _JoinAppState extends State<JoinApp> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, initialIndex: 1, length: 2);
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
//        leading: IconButton(
//          icon: Icon(
//            Icons.keyboard_backspace,
//          ),
//          onPressed: () => Navigator.pop(context),
//        ),
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Theme.of(context).accentColor,
            labelColor: Theme.of(context).accentColor,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w800,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w800,
            ),
            tabs: <Widget>[
              Tab(
                text: "Register",
              ),
              Tab(
                text: "Login",
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            RegisterScreen(),
            LoginScreen(),
          ],
        ),
      ),
    );
  }
}
