import 'package:quickfix/screens/cart.dart';
import 'package:quickfix/screens/favorite_screen.dart';
import 'package:quickfix/screens/home.dart';
import 'package:quickfix/screens/join.dart';
import 'package:quickfix/screens/notifications.dart';
import 'package:quickfix/screens/post_job.dart';
import 'package:quickfix/screens/profile.dart';
import 'package:quickfix/screens/search.dart';
import 'package:quickfix/util/Utils.dart';
import 'package:quickfix/util/const.dart';
import 'package:quickfix/widgets/badge.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PageController _pageController;
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Constants.darkAccent);
    FlutterStatusbarcolor.setNavigationBarColor(Constants.darkAccent);
    // FlutterStatusbarcolor
    // final user = Utils.getUserSession();
    // print(user);
    // if (user == null) {
    //   Navigator.of(context).push(
    //     MaterialPageRoute(
    //       builder: (BuildContext context) {
    //         return JoinApp();
    //       },
    //     ),
    //   );
    // }
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Constants.lightAccent,
//          automaticallyImplyLeading: false,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            Constants.appName,
          ),
          elevation:
              defaultTargetPlatform == TargetPlatform.android ? 1.0 : 0.0,
          actions: <Widget>[
            IconButton(
              color: Colors.white,
              icon: IconBadge(
                icon: Icons.notifications,
                size: 22.0,
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
              UserAccountsDrawerHeader(
                accountName: Text('Charles Archibong'),
                accountEmail: Text('charlesarchibong10@gmail.com'),
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
                      image: NetworkImage(
                        'https://www.pngarts.com/files/3/Cool-Avatar-Transparent-Image.png',
                      ),
                    ),
                  ),
                ),
                otherAccountsPictures: <Widget>[
                  Container(
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
                        image: NetworkImage(
                          'https://www.pngarts.com/files/3/Cool-Avatar-Transparent-Image.png',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              ListTile(
                title: Text('Jobs'),
                trailing: Icon(Icons.work),
                onTap: () {},
              ),
              ListTile(
                title: Text('Post Job(s)'),
                trailing: Icon(Icons.add_circle_outline),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) {
                    return PostJob();
                  }));
                },
              )
            ],
          ),
        ),
        body: Home(),
//        PageView(
//          physics: NeverScrollableScrollPhysics(),
//          controller: _pageController,
//          onPageChanged: onPageChanged,
//          children: <Widget>[
//            Home(),
//            FavoriteScreen(),
//            SearchScreen(),
//            CartScreen(),
//            Profile(),
//          ],
//        ),
//        bottomNavigationBar: BottomAppBar(
//          child: new Row(
//            mainAxisSize: MainAxisSize.max,
//            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//            children: <Widget>[
//              SizedBox(width: 7),
//              IconButton(
//                icon: Icon(
//                  Icons.home,
//                  size: 24.0,
//                ),
//                color: _page == 0
//                    ? Theme.of(context).accentColor
//                    : Theme.of(context).textTheme.caption.color,
//                onPressed: () => _pageController.jumpToPage(0),
//              ),
//              IconButton(
//                icon: Icon(
//                  Icons.favorite,
//                  size: 24.0,
//                ),
//                color: _page == 1
//                    ? Theme.of(context).accentColor
//                    : Theme.of(context).textTheme.caption.color,
//                onPressed: () => _pageController.jumpToPage(1),
//              ),
//              IconButton(
//                icon: Icon(
//                  Icons.search,
//                  size: 24.0,
//                  color: Theme.of(context).primaryColor,
//                ),
//                color: _page == 2
//                    ? Theme.of(context).accentColor
//                    : Theme.of(context).textTheme.caption.color,
//                onPressed: () => _pageController.jumpToPage(2),
//              ),
//              IconButton(
//                icon: IconBadge(
//                  icon: Icons.shopping_cart,
//                  size: 24.0,
//                ),
//                color: _page == 3
//                    ? Theme.of(context).accentColor
//                    : Theme.of(context).textTheme.caption.color,
//                onPressed: () => _pageController.jumpToPage(3),
//              ),
//              IconButton(
//                icon: Icon(
//                  Icons.person,
//                  size: 24.0,
//                ),
//                color: _page == 4
//                    ? Theme.of(context).accentColor
//                    : Theme.of(context).textTheme.caption.color,
//                onPressed: () => _pageController.jumpToPage(4),
//              ),
//              SizedBox(width: 7),
//            ],
//          ),
//          color: Theme.of(context).primaryColor,
//          shape: CircularNotchedRectangle(),
//        ),
//        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
//        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//        floatingActionButton: FloatingActionButton(
//          elevation: 4.0,
//          child: Icon(
//            Icons.search,
//          ),
//          onPressed: () => _pageController.jumpToPage(2),
//        ),
      ),
    );
  }

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }
}
