import 'package:flutter/cupertino.dart';

class PostJobProvider extends ChangeNotifier {
  PostJob() {}

  bool title = false;
  bool description = false;
  bool price = false;
  bool address = false;
  bool loading = false;
}
