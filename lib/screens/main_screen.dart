import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quickfix/providers/dashboard_provider.dart';
import 'package:quickfix/screens/dashboard.dart';
import 'package:quickfix/screens/favorite_screen.dart';
import 'package:quickfix/screens/home_old.dart';
import 'package:quickfix/screens/my_requests.dart';
import 'package:quickfix/screens/notifications.dart';
import 'package:quickfix/screens/pending_appointment.dart';
import 'package:quickfix/screens/post_job.dart';
import 'package:quickfix/screens/profile.dart';
import 'package:quickfix/screens/search.dart';
import 'package:quickfix/util/Utils.dart';
import 'package:quickfix/util/const.dart';
import 'package:quickfix/util/pending_request.dart';

class MainScreen extends StatefulWidget {
  MainScreenState mainScreenState = new MainScreenState();
  @override
  MainScreenState createState() => mainScreenState;
}

class MainScreenState extends State<MainScreen> {
  PageController pageController;
  final _scaffoledKey = GlobalKey<ScaffoldState>();
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Constants.darkAccent);
    FlutterStatusbarcolor.setNavigationBarColor(Constants.darkAccent);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    FlutterStatusbarcolor.setNavigationBarWhiteForeground(true);
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        key: _scaffoledKey,
        appBar: AppBar(
          backgroundColor: Constants.lightAccent,
//          automaticallyImplyLeading: false,
//          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            Constants.appName,
            style: TextStyle(
              color: Colors.white,
            ),
          ),

          actions: <Widget>[
            IconButton(
              color: Colors.white,
              icon: Badge(
                badgeContent: Text(
                  requests.length.toString(),
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                badgeColor: Colors.white,
                animationType: BadgeAnimationType.slide,
                toAnimate: true,
                child: FaIcon(
                  FontAwesomeIcons.comment,
                  size: 17.0,
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return;
                    },
                  ),
                );
              },
              tooltip: "Chats",
            ),
            IconButton(
              color: Colors.white,
              icon: Badge(
                badgeContent: Text(
                  requests.length.toString(),
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                badgeColor: Colors.white,
                animationType: BadgeAnimationType.slide,
                toAnimate: true,
                child: FaIcon(
                  FontAwesomeIcons.bell,
                  size: 17.0,
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return Notifications();
                    },
                  ),
                );
              },
              tooltip: "Notifications",
            ),
          ],
        ),
        drawer: Drawer(
          elevation: 10.0,
          child: ListView(
            children: <Widget>[
              _drawwerImage(),
              ListTile(
                title: Text('Dashboard'),
                leading: FaIcon(FontAwesomeIcons.chartPie),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => Dashboard(
                            pageController: pageController,
                          )));
                },
              ),
              ListTile(
                title: Text('User Requests'),
                leading: FaIcon(FontAwesomeIcons.luggageCart),
                onTap: () {
                  Navigator.of(context).pop();
                  navigationTapped(3);
                },
              ),
              ListTile(
                title: Text('My Request(s)'),
                leading: FaIcon(FontAwesomeIcons.luggageCart),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => MyRequests()));
                },
              ),
              ListTile(
                title: Text('Post Job'),
                leading: FaIcon(FontAwesomeIcons.plusCircle),
                onTap: () {
                  Navigator.of(context).pop();
                  navigationTapped(2);
                },
              ),
              ListTile(
                title: Text('Search Artisan'),
                leading: FaIcon(FontAwesomeIcons.search),
                onTap: () {
                  Navigator.of(context).pop();
                  navigationTapped(1);}
              ),
              ListTile(
                title: Text('Favourite Artisan'),
                leading: FaIcon(FontAwesomeIcons.heart),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) {
                    return FavoriteScreen();
                  }));
                },
              ),
              ListTile(
                title: Text('About'),
                leading: FaIcon(FontAwesomeIcons.exclamationTriangle),
                onTap: () {},
              ),
              ListTile(
                title: Text('Settings'),
                leading: FaIcon(FontAwesomeIcons.cogs),
                onTap: () {},
              ),
            ],
          ),
        ),
        body: Consumer<DashBoardProvider>(
          builder: (context, dashboardProvider, child) {
            return PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: pageController,
              onPageChanged: onPageChanged,
              children: <Widget>[
                HomeW(),
                SearchScreen(),
                PostJob(),
                PendingAppointment(),
                Profile(),
              ],
            );
          },
        ),
        bottomNavigationBar: BottomAppBar(
          child: Consumer<DashBoardProvider>(
            builder: (context, dashboardProvider, child) {
              return Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(width: 7),
                  IconButton(
                    icon: FaIcon(FontAwesomeIcons.home),
                    color: _page == 0
                        ? Theme.of(context).accentColor
                        : Theme.of(context).textTheme.caption.color,
                    onPressed: () => navigationTapped(0),
                  ),
                  IconButton(
                    icon: FaIcon(FontAwesomeIcons.search),
                    color: _page == 1
                        ? Theme.of(context).accentColor
                        : Theme.of(context).textTheme.caption.color,
                    onPressed: () => navigationTapped(1),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.search,
                      size: 24.0,
                      color: Theme.of(context).primaryColor,
                    ),
                    color: _page == 2
                        ? Theme.of(context).accentColor
                        : Theme.of(context).textTheme.caption.color,
                    onPressed: () => navigationTapped(2),
                  ),
                  InkWell(
                    onTap: () => navigationTapped(3),
                    child: Badge(
                      badgeContent: Text(
                        requests.length.toString(),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      badgeColor: Colors.red,
                      animationType: BadgeAnimationType.slide,
                      toAnimate: true,
                      child: FaIcon(
                        FontAwesomeIcons.luggageCart,
                        color: _page == 3
                            ? Theme.of(context).accentColor
                            : Theme.of(context).textTheme.caption.color,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: FaIcon(FontAwesomeIcons.user),
                    color: _page == 4
                        ? Theme.of(context).accentColor
                        : Theme.of(context).textTheme.caption.color,
                    onPressed: () => navigationTapped(4),
                  ),
                  SizedBox(width: 7),
                ],
              );
            },
          ),
          color: Theme.of(context).primaryColor,
          shape: CircularNotchedRectangle(),
        ),
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Consumer<DashBoardProvider>(
          builder: (context, dashboardProvider, child) {
            return FloatingActionButton(
              elevation: 4.0,
              child: FaIcon(FontAwesomeIcons.plusCircle),
              onPressed: () => navigationTapped(2),
            );
          },
        ),
      ),
    );
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  Widget _drawwerImage() {
    return FutureBuilder(
      future: Utils.getUserSession(),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? UserAccountsDrawerHeader(
                accountName: Text(
                  snapshot.data.firstName.toUpperCase() +
                      ' ' +
                      snapshot.data.lastName.toUpperCase(),
                ),
                accountEmail: Text(snapshot.data.email),
                currentAccountPicture: Container(
                  height: 200,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: Constants.lightAccent, width: 1)),
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
//                  width: MediaQuery.of(context).size.width * 10.6,
                  child: ClipOval(
                    child: Image(
                      fit: BoxFit.contain,
                      image: AssetImage('assets/dp.png'),
                    ),
                  ),
                ),
              )
            : ProfileShimmer();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }
}
