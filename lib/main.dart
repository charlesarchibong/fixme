import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:quickfix/modules/artisan/provider/artisan_provider.dart';
import 'package:quickfix/modules/auth/provider/login_form_validation.dart';
import 'package:quickfix/modules/custom/view/walkthrough.dart';
import 'package:quickfix/modules/dashboard/provider/dashboard_provider.dart';
import 'package:quickfix/modules/job/provider/approve_bid_provider.dart';
import 'package:quickfix/modules/job/provider/my_request_provider.dart';
import 'package:quickfix/modules/job/provider/pending_job_provider.dart';
import 'package:quickfix/modules/job/provider/post_job_provider.dart';
import 'package:quickfix/modules/main_screen/view/main_screen.dart';
import 'package:quickfix/modules/main_screen/view/no_profile_image.dart';
import 'package:quickfix/modules/profile/model/user.dart';
import 'package:quickfix/modules/profile/provider/profile_provider.dart';
import 'package:quickfix/modules/rate_review/provider/rate_review_provider.dart';
import 'package:quickfix/modules/search/provider/search_provider.dart';
import 'package:quickfix/providers/app_provider.dart';
import 'package:quickfix/util/Utils.dart';
import 'package:quickfix/util/const.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

NotificationAppLaunchDetails notificationAppLaunchDetails;

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final user = await Utils.getUserSession();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor:
          Color.fromRGBO(153, 0, 153, 1.0), // navigation bar color
      statusBarColor: Color.fromRGBO(153, 0, 153, 1.0),
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  var initializationSettingsAndroid = AndroidInitializationSettings(
    '@mipmap/launcher_icon',
  );
  // Note: permissions aren't requested here just to demonstrate that can be done later using the `requestPermissions()` method
  // of the `IOSFlutterLocalNotificationsPlugin` class
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {
        didReceiveLocalNotificationSubject.add(ReceivedNotification(
            id: id, title: title, body: body, payload: payload));
      });
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    selectNotificationSubject.add(payload);
  });
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => LoginFormValidation()),
        ChangeNotifierProvider(create: (_) => PostJobProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => DashBoardProvider()),
        ChangeNotifierProvider(create: (_) => PendingJobProvider()),
        ChangeNotifierProvider(create: (_) => MyRequestProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => RequestArtisanService()),
        ChangeNotifierProvider(create: (_) => ApprovedBidProvider()),
        ChangeNotifierProvider(create: (_) => RateReviewProvider()),
      ],
      child: MyApp(
        sp: prefs,
        user: user,
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  final SharedPreferences sp;
  final User user;

  const MyApp({Key key, this.sp, this.user}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void _requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body)
              : null,
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Ok'),
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();

                print(' ejhw aje aj fej');
              },
            )
          ],
        ),
      );
    });
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      // await Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => SecondScreen(payload)),
      // );
      print('a jne faj fej faf eanj few aeh');
    });
  }

  @override
  void initState() {
    _requestIOSPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
    super.initState();
  }

  @override
  void dispose() {
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (BuildContext context, AppProvider appProvider, Widget child) {
        return MaterialApp(
          key: appProvider.key,
          debugShowCheckedModeBanner: false,
          navigatorKey: appProvider.navigatorKey,
          title: Constants.appName,
          theme: appProvider.theme,
          home: widget.sp.get('user') != null
              ? widget.user.profilePicture == null ||
                      widget.user.profilePicture == 'no_picture_upload'
                  ? NoProfileImage()
                  : MainScreen()
              : Walkthrough(),
        );
      },
    );
  }
}
