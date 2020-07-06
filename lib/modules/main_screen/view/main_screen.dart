import 'dart:io';

import 'package:badges/badges.dart';
import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:quickfix/helpers/flush_bar.dart';
import 'package:quickfix/helpers/notification.dart';
import 'package:quickfix/modules/chat/view/chats.dart';
import 'package:quickfix/modules/dashboard/provider/dashboard_provider.dart';
import 'package:quickfix/modules/dashboard/view/dashboard.dart';
import 'package:quickfix/modules/job/provider/pending_job_provider.dart';
import 'package:quickfix/modules/job/view/my_requests.dart';
import 'package:quickfix/modules/job/view/pending_appointment.dart';
import 'package:quickfix/modules/job/view/post_job.dart';
import 'package:quickfix/modules/main_screen/view/home_old.dart';
import 'package:quickfix/modules/profile/provider/profile_provider.dart';
import 'package:quickfix/modules/profile/view/profile.dart';
import 'package:quickfix/modules/search/view/search.dart';
import 'package:quickfix/services/network/network_service.dart';
import 'package:quickfix/util/Utils.dart';
import 'package:quickfix/util/const.dart';
import 'package:quickfix/util/content_type.dart';
import 'package:quickfix/util/pending_request.dart';

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }

  // Or do other work.
}

class MainScreen extends StatefulWidget {
  MainScreenState mainScreenState = new MainScreenState();

  @override
  MainScreenState createState() => mainScreenState;
}

class MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AppLifecycleState _notification;

  PageController pageController;
  final _scaffoledKey = GlobalKey<ScaffoldState>();
  int _page = 0;
  int jobLength = 0;
  Location location;
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  Future<void> getPendingRequest() async {
    // print('snjfna');
    final pendingJobProvider =
        Provider.of<PendingJobProvider>(context, listen: false);
    await pendingJobProvider.getPendingRequest();
  }

  void getMessage() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        if (message['data']['notification_type'] == 'new_project') {
          FlushBarCustomHelper.showInfoFlushbarWithActionNot(
              context,
              'Job Around you',
              'New job is available around you',
              'View Job', () {
            navigationTapped(3);
          });
        }
        print("onMessage: $message");
        String msg = 'notibody';
        String name = 'chatapp';
        if (Platform.isIOS) {
          msg = message['aps']['alert']['body'];
          name = message['aps']['alert']['title'];
        } else {
          msg = message['notification']['body'];
          name = message['notification']['title'];
        }

        if (Platform.isIOS) {
          sendLocalNotification(name, msg);
        } else {
          sendLocalNotification(name, msg);
        }
      },
      onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        //_navigateToItemDetail(message);
        print(message['data']['notification_type']);
        if (message['data']['notification_type'] == 'new_project') {
          FlushBarCustomHelper.showInfoFlushbarWithActionNot(
              context,
              'Job Around you',
              'New job is available around you',
              'View Job', () {
            navigationTapped(3);
          });
        }
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        print(message['data']['notification_type']);
        if (message['data']['notification_type'] == 'new_project') {
          FlushBarCustomHelper.showInfoFlushbarWithActionNot(
              context,
              'Job Around you',
              'New job is available around you',
              'View Job', () {
            navigationTapped(3);
          });
        }
      },
    );

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.getToken().then((token) {
      print(token);
    });
  }

  @override
  Widget build(BuildContext context) {
    setStatusBar();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor:
            Color.fromRGBO(153, 0, 153, 1.0), // navigation bar color
        statusBarColor: Color.fromRGBO(153, 0, 153, 1.0),
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    return WillPopScope(
      onWillPop: () {
        setStatusBar();
        return Future.value(false);
      },
      child: Scaffold(
        key: _scaffoledKey,
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(153, 0, 153, 1.0),
//          automaticallyImplyLeading: false,
//          centerTitle: true,
//Charles added
          brightness: Brightness.dark,
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
                    builder: (_) => Chats(),
                  ),
                );
              },
              tooltip: "Chats",
            ),
            // IconButton(
            //   color: Colors.white,
            //   icon: Badge(
            //     badgeContent: Text(
            //       requests.length.toString(),
            //       style: TextStyle(
            //         color: Colors.black,
            //       ),
            //     ),
            //     badgeColor: Colors.white,
            //     animationType: BadgeAnimationType.slide,
            //     toAnimate: true,
            //     child: FaIcon(
            //       FontAwesomeIcons.bell,
            //       size: 17.0,
            //     ),
            //   ),
            //   onPressed: () {
            //     Navigator.of(context).push(
            //       MaterialPageRoute(
            //         builder: (BuildContext context) {
            //           return Notifications();
            //         },
            //       ),
            //     );
            //   },
            //   tooltip: "Notifications",
            // ),
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
                title: Text('Jobs Around me'),
                leading: Badge(
                  badgeContent: Consumer<PendingJobProvider>(
                    builder: (
                      BuildContext context,
                      PendingJobProvider pendingJobProvider,
                      Widget child,
                    ) {
                      return Text(
                        pendingJobProvider.listOfJobs.length.toString(),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      );
                    },
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
                onTap: () {
                  Navigator.of(context).pop();
                  navigationTapped(3);
                },
              ),
              ListTile(
                title: Text('My Job(s)'),
                leading: FaIcon(FontAwesomeIcons.luggageCart),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MyRequests(),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text('Post Job'),
                leading: FaIcon(
                  FontAwesomeIcons.plusCircle,
                  color: _page == 2
                      ? Theme.of(context).accentColor
                      : Theme.of(context).textTheme.caption.color,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  navigationTapped(2);
                },
              ),
              ListTile(
                title: Text('Search Artisan'),
                leading: FaIcon(
                  FontAwesomeIcons.search,
                  color: _page == 1
                      ? Theme.of(context).accentColor
                      : Theme.of(context).textTheme.caption.color,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  navigationTapped(1);
                },
              ),
              // ListTile(
              //   title: Text('Favourite Artisan'),
              //   leading: FaIcon(FontAwesomeIcons.heart),
              //   onTap: () {
              //     Navigator.of(context).push(
              //       MaterialPageRoute(
              //         builder: (
              //           BuildContext context,
              //         ) {
              //           return FavoriteScreen();
              //         },
              //       ),
              //     );
              //   },
              // ),
              ListTile(
                title: Text('My Profile'),
                leading: FaIcon(
                  FontAwesomeIcons.userCircle,
                  color: _page == 4
                      ? Theme.of(context).accentColor
                      : Theme.of(context).textTheme.caption.color,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  navigationTapped(4);
                },
              ),
              // ListTile(
              //   title: Text('Settings'),
              //   leading: FaIcon(FontAwesomeIcons.cogs),
              //   onTap: () {},
              // ),
              // AboutListTile(
              //   applicationIcon: Image.asset(
              //     "assets/icon-logo.png",
              //     width: 50,
              //   ),
              //   applicationName: Constants.appName,
              //   applicationVersion: Constants.appVersion,
              //   applicationLegalese: Constants.lagelSee,
              //   icon: FaIcon(FontAwesomeIcons.exclamationTriangle),
              //   child: Text('About'),
              // ),
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
                      badgeContent: Consumer<PendingJobProvider>(
                        builder: (
                          BuildContext context,
                          PendingJobProvider pendingJobProvider,
                          Widget child,
                        ) {
                          return Text(
                            pendingJobProvider.listOfJobs.length.toString(),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          );
                        },
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
                currentAccountPicture: Consumer<ProfileProvider>(
                  builder: (BuildContext context,
                      ProfileProvider profileProvider, Widget child) {
                    return Container(
                      height: 200,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: profileProvider.profilePicture == null
                                ? AssetImage(
                                    "assets/dp.png",
                                  )
                                : NetworkImage(
                                    profileProvider.profilePicture,
                                  ),
                          ),
                          border: Border.all(
                              color: Constants.lightAccent, width: 1)),
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      width: MediaQuery.of(context).size.width * 10.6,
                    );
                  },
                ))
            : ProfileShimmer();
      },
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    _initLocalNotification();
    _firebaseMessaging.getToken().then((token) {
      print('on message $token');
    });
    getMessage();
    getPendingRequest();
    setStatusBar();
    pageController = PageController();
    location = new Location();
    sendDeviceDetails();
    location.onLocationChanged.listen((LocationData locationData) {
      sendLocationToServer(locationData);
    });
    super.initState();
//    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
//        statusBarColor: Constants.darkAccent, // Color for Android
//        systemNavigationBarColor: Constants.darkAccent,
//        statusBarIconBrightness: Brightness.dark,
//        systemNavigationBarIconBrightness: Brightness.dark,
//        statusBarBrightness:
//            Brightness.dark // Dark == white status bar -- for IOS.
//        ));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    pageController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _notification = state;
    });
    setStatusBar();
  }

  void setStatusBar() async {
    setState(() {
      FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
      FlutterStatusbarcolor.setNavigationBarWhiteForeground(true);
      FlutterStatusbarcolor.setStatusBarColor(Color.fromRGBO(153, 0, 153, 1.0));
      FlutterStatusbarcolor.setNavigationBarColor(
        Color.fromRGBO(153, 0, 153, 1.0),
      );
    });
  }

  Future sendDeviceDetails() async {
    try {
      final token = await NotificationHelper().getToken();
      String device_os;
      String device_type;
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
        device_os = 'Android';
        device_type =
            androidDeviceInfo.manufacturer + ' - ' + androidDeviceInfo.model;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
        device_type = 'IOS ' + iosDeviceInfo.model;
        device_os = iosDeviceInfo.systemName;
      }
      print(device_os);
      print(device_type);
      final user = await Utils.getUserSession();
      final apiKey = await Utils.getApiKey();
      final String url = Constants.savedDeviceDetails;
      Map<String, String> headers = {'Bearer': '$apiKey'};
      Map<String, dynamic> body = {
        'mobile': user.phoneNumber,
        'device_token': token,
        'device_os': device_os,
        'device_type': device_type,
      };
      final response = await NetworkService().post(
        url: url,
        body: body,
        contentType: ContentType.URL_ENCODED,
        headers: headers,
      );
      print(response.data);
      print(response.data);
      print(response.data);
    } catch (e) {
      if (e is DioError) {
        print(e.message);
      }
      print(e.toString());
    }
  }

  _initLocalNotification() async {
    if (Platform.isIOS) {
      // set iOS Local notification.
      var initializationSettingsAndroid =
          AndroidInitializationSettings('ic_launcher');
      var initializationSettingsIOS = IOSInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
        onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
      );
      var initializationSettings = InitializationSettings(
          initializationSettingsAndroid, initializationSettingsIOS);
      await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onSelectNotification: _selectNotification);
    } else {
      // set Android Local notification.
      var initializationSettingsAndroid =
          AndroidInitializationSettings('ic_launcher');
      var initializationSettingsIOS = IOSInitializationSettings(
          onDidReceiveLocalNotification: _onDidReceiveLocalNotification);
      var initializationSettings = InitializationSettings(
          initializationSettingsAndroid, initializationSettingsIOS);
      await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onSelectNotification: _selectNotification);
    }
  }

  Future _onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {}

  Future _selectNotification(String payload) async {}

  sendLocalNotification(name, msg) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin
        .show(0, name, msg, platformChannelSpecifics, payload: 'item x');
  }

  Future sendLocationToServer(LocationData locationData) async {
    try {
      final user = await Utils.getUserSession();
      final apiKey = await Utils.getApiKey();
      final String url = Constants.updateLocationUrl;
      Map<String, String> headers = {'Bearer': '$apiKey'};
      Map<String, dynamic> body = {
        'mobile': user.phoneNumber,
        'latitude': locationData.latitude,
        'longitude': locationData.longitude,
      };
      await NetworkService().post(
        url: url,
        body: body,
        contentType: ContentType.URL_ENCODED,
        headers: headers,
      );
    } catch (e) {
      if (e is DioError) {
        print(e.message);
      }
      print(e.toString());
    }
  }

  void onPageChanged(int page) {
//    setStatusBar();
    setState(() {
      this._page = page;
    });
  }
}
