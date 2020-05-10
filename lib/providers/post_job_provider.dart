import 'package:flutter/cupertino.dart';

class PostJobProvider extends ChangeNotifier {
  PostJobProvider();

  bool title = false;
  bool description = false;
  bool price = false;
  bool address = false;
  bool loading = false;
}
