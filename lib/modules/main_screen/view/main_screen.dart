import 'dart:io';

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logger/logger.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:quickfix/providers/app_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../helpers/flush_bar.dart';
import '../../../main.dart';
import '../../../services/firebase/messeage_count.dart';
import '../../../util/Utils.dart';
import '../../../util/const.dart';
import '../../artisan/provider/artisan_provider.dart';
import '../../artisan/view/my_requested_service.dart';
import '../../artisan/view/my_service_requests.dart';
import '../../chat/view/chats.dart';
import '../../dashboard/provider/dashboard_provider.dart';
import '../../dashboard/view/dashboard.dart';
import '../../job/provider/approve_bid_provider.dart';
import '../../job/provider/pending_job_provider.dart';
import '../../job/view/approved_jobs.dart';
import '../../job/view/my_jobs.dart';
import '../../job/view/pending_appointment.dart';
import '../../job/view/post_job.dart';
import '../../profile/model/user.dart';
import '../../profile/provider/profile_provider.dart';
import '../../profile/view/profile.dart';
import '../../search/view/search.dart';
import '../../setting/view/settings.dart';
import '../../transfer/view/transfer_fund.dart';
import 'home_old.dart';

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
    print('background message');
    print(data);
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
    print('background message II');
    print(notification);
  }
  print('background message III');
  print('background message III');
  print('background message III');
  // Or do other work.
  return Future.value(true);
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
  User currentUser;

  PageController pageController;
  final _scaffoledKey = GlobalKey<ScaffoldState>();
  int _page = 0;
  int jobLength = 0;
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

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
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
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

        if (message['data']['notification_type'] ==
            'completed_service_request') {
          FlushBarCustomHelper.showInfoFlushbarWithActionNot(
              context,
              'Request Completed/Payment',
              '${message['data']['requesting_mobile']} has completed your requested service and require his payment, Account Number - ${message['data']['account_number']}, Bank Name: Providus Bank',
              'Drop a Review', () {
            // navigationTapped(3);
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
        return Future.value(false);
      },
      child: Scaffold(
        key: _scaffoledKey,
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(153, 0, 153, 1.0),
          //          automaticallyImplyLeading: false,
          //          centerTitle: true,
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
                badgeContent: StreamBuilder<QuerySnapshot>(
                  stream: MessageCount(
                    messageCountCollection: Firestore.instance.collection(
                      FIREBASE_MESSAGE_COUNT,
                    ),
                  ).getMessageCount(
                    receiver: currentUser?.phoneNumber,
                    isRead: false,
                  ),
                  builder: (context, snapshot) {
                    return Text(
                      snapshot.data?.documents?.length.toString(),
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    );
                  },
                ),
                badgeColor: Colors.white,
                animationType: BadgeAnimationType.slide,
                toAnimate: true,
                child: FaIcon(
                  FontAwesomeIcons.comment,
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
            IconButton(
              color: Colors.white,
              icon: Badge(
                badgeContent: Consumer<ArtisanProvider>(
                  builder: (
                    BuildContext context,
                    ArtisanProvider artisanProvider,
                    Widget child,
                  ) {
                    return FutureBuilder<Object>(
                        future: artisanProvider.getMyRequestedService(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              artisanProvider.serviceRequests?.length
                                  .toString(),
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            );
                          }
                          return Text(
                            artisanProvider.serviceRequests?.length.toString(),
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          );
                        });
                  },
                ),
                // badgeColor: Colors.red,
                badgeColor: Colors.white,

                animationType: BadgeAnimationType.slide,
                toAnimate: true,
                child: FaIcon(
                  FontAwesomeIcons.checkSquare,
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return MyServiceRequests();
                    },
                  ),
                );
              },
              tooltip: "Requests",
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
                  if (Provider.of<AppProvider>(context, listen: false)
                          .userRole !=
                      'artisan') {
                    FlushBarCustomHelper.showInfoFlushbar(
                      context,
                      'Information',
                      'Dear ${currentUser.firstName} ${currentUser.lastName}, this feature is only available for Sevice Providers, please update your account to an ARTISAN from your profile page',
                    );
                    return;
                  }

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => Dashboard(
                        pageController: pageController,
                      ),
                    ),
                  );
                },
              ),

              ListTile(
                title: Text('My Chats'),
                leading: Badge(
                  badgeContent: StreamBuilder<QuerySnapshot>(
                    stream: MessageCount(
                      messageCountCollection: Firestore.instance.collection(
                        FIREBASE_MESSAGE_COUNT,
                      ),
                    ).getMessageCount(
                      receiver: currentUser?.phoneNumber,
                      isRead: false,
                    ),
                    builder: (context, snapshot) {
                      return Text(
                        snapshot.data?.documents?.length.toString(),
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
                    FontAwesomeIcons.commentAlt,
                    color: Theme.of(context).textTheme.caption.color,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => Chats(),
                    ),
                  );
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
                  if (Provider.of<AppProvider>(context, listen: false)
                          .userRole !=
                      'artisan') {
                    FlushBarCustomHelper.showInfoFlushbar(
                      context,
                      'Information',
                      'Dear ${currentUser.firstName} ${currentUser.lastName}, this feature is only available for Sevice Providers, please update your account to an ARTISAN from your profile page',
                    );
                    return;
                  }
                  Navigator.of(context).pop();
                  navigationTapped(3);
                },
              ),
              ListTile(
                title: Text('My Job Bids'),
                leading: Badge(
                  badgeContent: Consumer<ApprovedBidProvider>(
                    builder: (
                      BuildContext context,
                      ApprovedBidProvider approvedBidProvider,
                      Widget child,
                    ) {
                      return Text(
                        approvedBidProvider.approvedBids.length.toString(),
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
                    FontAwesomeIcons.checkSquare,
                    color: Theme.of(context).textTheme.caption.color,
                  ),
                ),
                onTap: () {
                  if (Provider.of<AppProvider>(context, listen: false)
                          .userRole !=
                      'artisan') {
                    FlushBarCustomHelper.showInfoFlushbar(
                      context,
                      'Information',
                      'Dear ${currentUser.firstName} ${currentUser.lastName}, this feature is only available for Sevice Providers, please update your account to an ARTISAN from your profile page',
                    );
                    return;
                  }
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ApprovedBid(),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text('My Posted Job(s)'),
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
                title: Text('Requests from Users'),
                leading: Badge(
                  badgeContent: Consumer<ArtisanProvider>(
                    builder: (
                      BuildContext context,
                      ArtisanProvider artisanProvider,
                      Widget child,
                    ) {
                      return Text(
                        artisanProvider.serviceRequests?.length.toString(),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                  // badgeColor: Colors.red,
                  animationType: BadgeAnimationType.slide,
                  toAnimate: true,
                  child: FaIcon(
                    FontAwesomeIcons.checkSquare,
                    color: Theme.of(context).textTheme.caption.color,
                  ),
                ),
                onTap: () {
                  if (Provider.of<AppProvider>(context, listen: false)
                          .userRole !=
                      'artisan') {
                    FlushBarCustomHelper.showInfoFlushbar(
                      context,
                      'Information',
                      'Dear ${currentUser.firstName} ${currentUser.lastName}, this feature is only available for Sevice Providers, please update your account to an ARTISAN from your profile page',
                    );
                    return;
                  }
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MyServiceRequests(),
                    ),
                  );
                },
              ),

              ListTile(
                title: Text('My Requested Service'),
                leading: Badge(
                  badgeContent: Consumer<ArtisanProvider>(
                    builder: (
                      BuildContext context,
                      ArtisanProvider artisanProvider,
                      Widget child,
                    ) {
                      return Text(
                        artisanProvider.myRequestedRequest?.length.toString(),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                  // badgeColor: Colors.red,
                  animationType: BadgeAnimationType.slide,
                  toAnimate: true,
                  child: FaIcon(
                    FontAwesomeIcons.checkSquare,
                    color: Theme.of(context).textTheme.caption.color,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MyRequestedService(),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text('Search Service'),
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
                title: Text('Transfer Fund'),
                leading: FaIcon(
                  FontAwesomeIcons.moneyCheck,
                  color: Theme.of(context).textTheme.caption.color,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (
                        BuildContext context,
                      ) {
                        return TransferFund();
                      },
                    ),
                  );
                },
              ),
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
              ListTile(
                title: Text('Settings'),
                leading: FaIcon(
                  FontAwesomeIcons.cogs,
                  color: Theme.of(context).textTheme.caption.color,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (
                        BuildContext context,
                      ) {
                        return Settings();
                      },
                    ),
                  );
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
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  SizedBox(width: 7),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      IconButton(
                        icon: FaIcon(FontAwesomeIcons.home),
                        color: _page == 0
                            ? Theme.of(context).accentColor
                            : Theme.of(context).textTheme.caption.color,
                        onPressed: () => navigationTapped(0),
                      ),
                      Text(
                        'Home',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _page == 0
                              ? Theme.of(context).accentColor
                              : Theme.of(context).textTheme.caption.color,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        icon: FaIcon(
                          FontAwesomeIcons.plusCircle,
                        ),
                        color: _page == 2
                            ? Theme.of(context).accentColor
                            : Theme.of(context).textTheme.caption.color,
                        onPressed: () => navigationTapped(2),
                      ),
                      Text(
                        'Post Job',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _page == 2
                              ? Theme.of(context).accentColor
                              : Theme.of(context).textTheme.caption.color,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        icon: FaIcon(FontAwesomeIcons.search),
                        color: _page == 1
                            ? Theme.of(context).accentColor
                            : Theme.of(context).textTheme.caption.color,
                        onPressed: () => navigationTapped(1),
                      ),
                      Text(
                        'Search Service',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _page == 1
                              ? Theme.of(context).accentColor
                              : Theme.of(context).textTheme.caption.color,
                        ),
                      ),
                    ],
                  ),
                  Provider.of<AppProvider>(context).userRole == 'artisan'
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              icon: FaIcon(FontAwesomeIcons.luggageCart),
                              color: _page == 3
                                  ? Theme.of(context).accentColor
                                  : Theme.of(context).textTheme.caption.color,
                              onPressed: () => navigationTapped(3),
                            ),
                            Text(
                              'Jobs',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _page == 3
                                    ? Theme.of(context).accentColor
                                    : Theme.of(context).textTheme.caption.color,
                              ),
                            ),
                          ],
                        )
                      : Text(''),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        icon: FaIcon(FontAwesomeIcons.user),
                        color: _page == 4
                            ? Theme.of(context).accentColor
                            : Theme.of(context).textTheme.caption.color,
                        onPressed: () => navigationTapped(4),
                      ),
                      Text(
                        'Profile',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _page == 4
                              ? Theme.of(context).accentColor
                              : Theme.of(context).textTheme.caption.color,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 7),
                ],
              );
            },
          ),
          color: Theme.of(context).primaryColor,
          shape: CircularNotchedRectangle(),
        ),
        // floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // floatingActionButton: Consumer<DashBoardProvider>(
        //   builder: (context, dashboardProvider, child) {
        //     return FloatingActionButton(
        //       elevation: 4.0,
        //       child: FaIcon(FontAwesomeIcons.plusCircle),
        //       onPressed: () => navigationTapped(2),
        //     );
        //   },
        // ),
      ),
    );
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  Widget _drawwerImage() {
    return FutureBuilder<User>(
      future: Utils.getUserSession(),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? UserAccountsDrawerHeader(
                accountName: Text(
                  snapshot.data.firstName.toUpperCase() +
                      ' ' +
                      snapshot.data.lastName.toUpperCase(),
                ),
                accountEmail: Text(snapshot.data.fullNumber),
                currentAccountPicture: Consumer<ProfileProvider>(
                  builder: (BuildContext context,
                      ProfileProvider profileProvider, Widget child) {
                    return FutureBuilder<String>(
                        future: Utils.getProfilePicture(),
                        builder: (context, pic) {
                          return Container(
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: pic.hasData
                                    ? NetworkImage(
                                        pic?.data,
                                      )
                                    : AssetImage('assets/dp.png'),
                              ),
                              border: Border.all(
                                color: Constants.lightAccent,
                                width: 1,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            width: MediaQuery.of(context).size.width * 10.6,
                          );
                        });
                  },
                ))
            : Container(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    pageController = PageController();
    getCurrentUser();
    // try {
    //   versionCheck(context);
    // } catch (e) {
    //   print(e);
    // }
    getMessage();
    _firebaseMessaging.getToken().then((token) {
      print('on message $token');
    });

    setStatusBar();

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

  versionCheck(context) async {
    //Get Current installed version of app
    final PackageInfo info = await PackageInfo.fromPlatform();
    double currentVersion =
        double.parse(info.version.trim().replaceAll(".", ""));

    //Get Latest version info from firebase config
    final RemoteConfig remoteConfig = await RemoteConfig.instance;

    try {
      // Using default duration to force fetching from remote server.
      await remoteConfig.fetch(expiration: const Duration(seconds: 0));
      await remoteConfig.activateFetched();
      remoteConfig.getString('force_update_current_version');
      double newVersion = double.parse(
        remoteConfig
            .getString('force_update_current_version')
            .trim()
            .replaceAll(".", ""),
      );
      Logger().i(
        double.parse(
          remoteConfig.getString('force_update_current_version'),
        ),
      );
      if (newVersion > currentVersion) {
        _showVersionDialog(context);
      }
    } on FetchThrottledException catch (exception) {
      // Fetch throttled.
      print(exception);
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be '
          'used');
    }
  }

  _showVersionDialog(context) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "New Update Available";
        String message =
            "There is a newer version of app available please update it now.";
        String btnLabel = "Update Now";
        String btnLabelCancel = "Later";
        return Platform.isIOS
            ? new CupertinoAlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  FlatButton(
                    child: Text(btnLabel),
                    onPressed: () => _launchURL(Constants.APP_STORE_URL),
                  ),
                  FlatButton(
                    child: Text(btnLabelCancel),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              )
            : new AlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  FlatButton(
                    child: Text(btnLabel),
                    onPressed: () => _launchURL(Constants.PLAY_STORE_URL),
                  ),
                  FlatButton(
                    child: Text(btnLabelCancel),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              );
      },
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  getCurrentUser() async {
    final user = await Utils.getUserSession();
    setState(() {
      currentUser = user;
    });
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
    // showUpdatePictureDialog();
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

  void showUpdatePictureDialog() async {
    final user = await Utils.getUserSession();
    if (user.profilePicture == null ||
        user.profilePicture == 'no_picture_upload') {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ), //this right here
                child: Container(
                  height: 400,
                  child: Padding(
                    padding: const EdgeInsets.all(
                      12.0,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: SvgPicture.asset(
                            'assets/sad.svg',
                            semanticsLabel: 'So Sad',
                            width: 230,
                          ),
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
                              RaisedButton(
                                child: Text(
                                  "Click here to update",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                color: Theme.of(context).accentColor,
                                onPressed: () async {
                                  navigationTapped(4);
                                  // profileProvider.getImage().then((value) {
                                  //   FlushBarCustomHelper.showInfoFlushbar(
                                  //     context,
                                  //     'Success',
                                  //     'Profile picture updated',
                                  //   );
                                  //   profileProvider.setNotLoading();
                                  // }).catchError((e) {
                                  //   FlushBarCustomHelper.showInfoFlushbar(
                                  //     context,
                                  //     'Error',
                                  //     'Profile picture was not updated, please try again',
                                  //   );
                                  //   profileProvider.setNotLoading();
                                  // });
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
    }
  }

  void onPageChanged(int page) {
    //    setStatusBar();
    setState(() {
      this._page = page;
    });
  }

  void sendLocalNotification(String name, String msg) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
      presentBadge: true,
      presentAlert: true,
      presentSound: true,
    );
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      '$name',
      '$msg',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }
}
