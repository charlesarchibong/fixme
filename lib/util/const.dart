import 'package:flutter/material.dart';

const FIXME_TOKEN = 'FIXME_LOGIN_TOKEN';
const FCM_KEY = 'FCM_KEY';
const SMART_LOCK = 'SMART_LOCK';
const FIREBASE_MESSAGE_COUNT = 'message_count';

class Constants {
  static String appName = "Fixme Business";
  static String appVersion = "5.0.0";
  static String lagelSee =
      "All Right Reserved, and all information store in this application is secure and is only use for Identification";
  static String baseUrl = "https://manager.fixme.ng/";
  static String updateProfileView =
      "https://manager.fixme.ng/profile-views-update";
  static String savedDeviceDetails =
      "https://manager.fixme.ng/mtk-details-update";
  static String serviceImageUrl = "https://manager.fixme.ng/service-images";
  static String requestArtisanRequest =
      "https://manager.fixme.ng/service-request";
  static String createUserUrl = "reg-user";
  static String uploadUrl = 'https://uploads.fixme.ng/thumbnails/';
  static String updateLocationUrl = 'https://manager.fixme.ng/gpsl';
  static String getArtisanByLocationUrl =
      'https://manager.fixme.ng/near-artisans';
  static String getMoreArtisan =
      "https://manager.fixme.ng/load-more-service-providers";
  static String loginUserUrl = "m-login";
  static String addSubService = "add-sub-service";
  static String userInfo = "user-info";
  static String getMyRequestEndpoint = 'https://manager.fixme.ng/user-projects';
  static String getJobBidders = 'https://manager.fixme.ng/get-bids';
  static String approveBid = 'https://manager.fixme.ng/approve-bid';
  static String rejectBid = 'https://manager.fixme.ng/reject-bid';
  static String searchArtisans = 'https://manager.fixme.ng/search-artisans';

  static const APP_STORE_URL =
      'https://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftwareUpdate?id=com.fixme.business&mt=8';
  static const PLAY_STORE_URL =
      'https://play.google.com/store/apps/details?id=com.fixme.business';
  static const SENTRY_DSN =
      'https://31ef3de468154251b8876f56608cc328@o431422.ingest.sentry.io/5382465';

  //Colors for theme
//  Color(0xfffcfcff);
  static Color lightPrimary = Color(0xfffcfcff);
  static Color darkPrimary = Colors.black;
//  static Color lightAccen.t = Color(0xffFFA000);
//  static Color darkAccent = Color(0xffFFA000);
  static Color lightBG = Color(0xfffcfcff);
  static Color darkBG = Colors.black;
  static Color ratingBG = Color.fromRGBO(153, 0, 153, 1.0);
  static Color lightAccent = Color.fromRGBO(153, 0, 153, 1.0);
  static Color darkAccent = Color.fromRGBO(153, 0, 153, 1.0);
  static Map<int, Color> colorScratch = {
    50: Color.fromRGBO(153, 0, 153, .1),
    100: Color.fromRGBO(153, 0, 153, .2),
    200: Color.fromRGBO(153, 0, 153, .3),
    300: Color.fromRGBO(153, 0, 153, .4),
    400: Color.fromRGBO(153, 0, 153, .5),
    500: Color.fromRGBO(153, 0, 153, .6),
    600: Color.fromRGBO(153, 0, 153, .7),
    700: Color.fromRGBO(153, 0, 153, .8),
    800: Color.fromRGBO(153, 0, 153, .9),
    900: Color.fromRGBO(153, 0, 153, 1),
  };
  // MaterialColor colorCustom = ;
  static ThemeData lightTheme = ThemeData(
    primarySwatch: MaterialColor(0xFF880E4F, colorScratch),
    // brightness: Brightness.light,
    backgroundColor: darkAccent,
    primaryColor: lightPrimary,
    accentColor: lightAccent,
    fontFamily: 'Popins',
    cursorColor: lightAccent,
    brightness: Brightness.light,
    textSelectionColor: Color.fromRGBO(153, 0, 153, 1),
    scaffoldBackgroundColor: lightBG,
    appBarTheme: AppBarTheme(
      color: Color.fromRGBO(153, 0, 153, 1.0),
      textTheme: TextTheme(),
      iconTheme: IconThemeData(
        color: Color.fromRGBO(153, 0, 153, 1.0),
      ),

//      iconTheme: IconThemeData(
//        color: lightAccent,
//      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    backgroundColor: darkAccent,
    textSelectionColor: Color.fromRGBO(153, 0, 153, 1),
    primaryColor: darkPrimary,
    accentColor: darkAccent,
    scaffoldBackgroundColor: darkBG,
    cursorColor: darkAccent,
    fontFamily: 'Popins',
    appBarTheme: AppBarTheme(
      color: Color.fromRGBO(153, 0, 153, 1.0),

      textTheme: TextTheme(),
      iconTheme: IconThemeData(color: Color(0xffffffff)),

//      iconTheme: IconThemeData(
//        color: darkAccent,
//      ),
    ),
  );
}
