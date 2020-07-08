import 'package:logger/logger.dart';

abstract class LoggerHelper {
  void debugPrint(String message);
  void errorPrint(String message);
  void warmingPrint(String message);
  void messagePrint(String message);
}

class CustomPrinter extends LogPrinter {
  final String className;

  CustomPrinter({this.className});
  @override
  List<String> log(LogEvent event) {
    var color = PrettyPrinter.levelColors[event.level];
    var emoji = PrettyPrinter.levelEmojis[event.level];

    print(color('$emoji $className - ${event.message}'));
  }
}
