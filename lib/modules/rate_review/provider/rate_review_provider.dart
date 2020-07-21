import 'package:flutter/cupertino.dart';

class RateReviewProvider with ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;
}
