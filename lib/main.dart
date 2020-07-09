import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quickfix/modules/artisan/provider/artisan_provider.dart';
import 'package:quickfix/modules/auth/provider/login_form_validation.dart';
import 'package:quickfix/modules/custom/view/walkthrough.dart';
import 'package:quickfix/modules/dashboard/provider/dashboard_provider.dart';
import 'package:quickfix/modules/job/provider/my_request_provider.dart';
import 'package:quickfix/modules/job/provider/pending_job_provider.dart';
import 'package:quickfix/modules/job/provider/post_job_provider.dart';
import 'package:quickfix/modules/main_screen/view/main_screen.dart';
import 'package:quickfix/modules/main_screen/view/no_profile_image.dart';
import 'package:quickfix/modules/profile/model/user.dart';
import 'package:quickfix/modules/profile/provider/profile_provider.dart';
import 'package:quickfix/modules/search/provider/search_provider.dart';
import 'package:quickfix/providers/app_provider.dart';
import 'package:quickfix/util/Utils.dart';
import 'package:quickfix/util/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      ],
      child: MyApp(
        sp: prefs,
        user: user,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final SharedPreferences sp;
  final User user;

  const MyApp({Key key, this.sp, this.user}) : super(key: key);

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
          home: sp.get('user') != null
              ? user.profilePicture == null ||
                      user.profilePicture == 'no_picture_upload'
                  ? NoProfileImage()
                  : MainScreen()
              : Walkthrough(),
        );
      },
    );
  }
}
