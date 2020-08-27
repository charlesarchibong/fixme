import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:quickfix/modules/transfer/view/transfer_fund.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sentry/sentry.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'modules/artisan/provider/artisan_provider.dart';
import 'modules/auth/provider/login_form_validation.dart';
import 'modules/auth/provider/security_pin_provider.dart';
import 'modules/dashboard/provider/dashboard_provider.dart';
import 'modules/job/provider/approve_bid_provider.dart';
import 'modules/job/provider/my_request_provider.dart';
import 'modules/job/provider/pending_job_provider.dart';
import 'modules/job/provider/post_job_provider.dart';
import 'modules/profile/provider/profile_provider.dart';
import 'modules/rate_review/provider/rate_review_provider.dart';
import 'modules/search/provider/search_provider.dart';
import 'modules/transfer/provider/transfer_provider.dart';
import 'providers/app_provider.dart';
import 'util/Utils.dart';
import 'util/const.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

NotificationAppLaunchDetails notificationAppLaunchDetails;
final SentryClient _sentry = new SentryClient(
  dsn: Constants.SENTRY_DSN,
);

bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

/// Reports [error] along with its [stackTrace] to Sentry.io.
Future<Null> _reportError(dynamic error, dynamic stackTrace) async {
  Logger().e('Caught error: $error');

  // Errors thrown in development mode are unlikely to be interesting. You can
  // check if you are running in dev mode using an assertion and omit sending
  // the report.
  if (isInDebugMode) {
    Logger().e(stackTrace);
    Logger().i('In dev mode. Not sending report to Sentry.io.');
    return;
  }

  print('Reporting to Sentry.io...');

  final SentryResponse response = await _sentry.captureException(
    exception: error,
    stackTrace: stackTrace,
  );

  if (response.isSuccessful) {
    Logger().i('Success! Event ID: ${response.eventId}');
  } else {
    Logger().e('Failed to report to Sentry.io: ${response.error}');
  }
}

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
  await DotEnv().load('.env');

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

  // This captures errors reported by the Flutter framework.
  FlutterError.onError = (FlutterErrorDetails details) async {
    if (isInDebugMode) {
      // In development mode simply print to console.
      FlutterError.dumpErrorToConsole(details);
    } else {
      // In production mode report to the application zone to report to
      // Sentry.
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };

  runZonedGuarded<Future<Null>>(() async {
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
          ChangeNotifierProvider(create: (_) => ArtisanProvider()),
          ChangeNotifierProvider(create: (_) => ApprovedBidProvider()),
          ChangeNotifierProvider(create: (_) => RateReviewProvider()),
          ChangeNotifierProvider(create: (_) => TransferProvider()),
          ChangeNotifierProvider(create: (_) => SecurityPinProvider()),
        ],
        child: MyApp(
          sp: prefs,
          userModel: user,
        ),
      ),
    );
  }, (error, stackTrace) async {
    await _reportError(error, stackTrace);
  });
}

class MyApp extends StatefulWidget {
  final SharedPreferences sp;
  final userModel;

  const MyApp({Key key, this.sp, this.userModel}) : super(key: key);

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
        // print(widget.sp.get('opened'));
        return MaterialApp(
          key: appProvider.key,
          debugShowCheckedModeBanner: false,
          navigatorKey: appProvider.navigatorKey,
          title: Constants.appName,
          // theme: appProvider.theme,
          theme: ThemeData(
            primarySwatch: MaterialColor(0xFF880E4F, Constants.colorScratch),
            // brightness: Brightness.light,
            backgroundColor: Constants.darkAccent,
            primaryColor: Constants.lightPrimary,
            textTheme: GoogleFonts.solwayTextTheme(TextTheme()),
            primaryTextTheme: GoogleFonts.solwayTextTheme(TextTheme()),
            accentColor: Constants.lightAccent,
            fontFamily: 'Popins',
            cursorColor: Constants.lightAccent,
            brightness: Brightness.light,
            accentTextTheme: GoogleFonts.solwayTextTheme(TextTheme()),
            textSelectionColor: Color.fromRGBO(153, 0, 153, 1),
            scaffoldBackgroundColor: Constants.lightBG,
            appBarTheme: AppBarTheme(
              color: Color.fromRGBO(153, 0, 153, 1.0),
              textTheme: GoogleFonts.solwayTextTheme(
                Theme.of(context).textTheme,
              ),
              iconTheme: IconThemeData(
                color: Color.fromRGBO(153, 0, 153, 1.0),
              ),

//      iconTheme: IconThemeData(
//        color: lightAccent,
//      ),
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            backgroundColor: Constants.darkAccent,
            textSelectionColor: Color.fromRGBO(153, 0, 153, 1),
            primaryColor: Constants.darkPrimary,
            textTheme: GoogleFonts.solwayTextTheme(TextTheme()),
            primaryTextTheme: GoogleFonts.solwayTextTheme(TextTheme()),
            accentColor: Constants.darkAccent,
            scaffoldBackgroundColor: Constants.darkBG,
            cursorColor: Constants.darkAccent,
            fontFamily: 'Popins',
            appBarTheme: AppBarTheme(
              color: Color.fromRGBO(153, 0, 153, 1.0),
              textTheme: GoogleFonts.solwayTextTheme(
                Theme.of(context).textTheme,
              ),
              iconTheme: IconThemeData(
                color: Color(0xffffffff),
              ),

//      iconTheme: IconThemeData(
//        color: darkAccent,
//      ),
            ),
          ),
          themeMode: appProvider.theme == Constants.lightTheme
              ? ThemeMode.light
              : ThemeMode.dark,
          home: widget.sp.get('opened') == null
              ? Walkthrough()
              : widget.sp.get('user') != null
                  ? widget.userModel?.profilePicture == null ||
                          widget.userModel?.profilePicture ==
                              'no_picture_upload'
                      ? NoProfileImage()
                      : widget.sp.get('exist') == false
                          ? EnterSecurityPin()
                          : MainScreen()
                  : LoginScreen(),
        );
      },
    );
  }
}
