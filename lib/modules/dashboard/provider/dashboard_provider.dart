import 'package:flutter/cupertino.dart';

class DashBoardProvider extends ChangeNotifier {
  PageController pageController = PageController();
  DashBoardProvider({this.pageController});
  //@depreciated
  void changePage(int index) {
    pageController = PageController();
    pageController.jumpToPage(index);
    notifyListeners();
  }
}
