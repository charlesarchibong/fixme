import 'package:logger/logger.dart';
import 'package:quickfix/helpers/logger_helper_interface.dart';

class CustomLogger extends LoggerHelper {
  Logger _logger;
  final String className;

  CustomLogger({this.className}) {
    _logger = Logger(
      printer: CustomPrinter(className: this.className),
    );
  }

  @override
  void debugPrint(String message) {
    _logger.d(message);
  }

  @override
  void errorPrint(String message) {
    _logger.e(message);
  }

  @override
  void messagePrint(String message) {
    _logger.i(message);
  }

  @override
  void warmingPrint(String message) {
    _logger.w(message);
  }
}
