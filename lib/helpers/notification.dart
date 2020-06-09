import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationHelper {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  Future<String> getToken() async {
    String token = await _firebaseMessaging.getToken();
    return token;
  }
// _firebaseMessaging.configure(
//     onLaunch: (Map<String, dynamic> message) {
//       print('onLaunch called');
//     },
//     onResume: (Map<String, dynamic> message) {
//       print('onResume called');
//     },
//     onMessage: (Map<String, dynamic> message) {
//       print('onMessage called');
//     },
//   );
//   _firebaseMessaging.subscribeToTopic('all');
//   _firebaseMessaging.requestNotificationPermissions(IosNotificationSettings(
//     sound: true,
//     badge: true,
//     alert: true,
//   ));
//   _firebaseMessaging.onIosSettingsRegistered
//       .listen((IosNotificationSettings settings) {
//     print('Hello');
//   });

// }
}
