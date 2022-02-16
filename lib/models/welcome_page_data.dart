// TODO: Figure out how to use provider in welcome screen, instead of using setState(). Which one is better in this simple case?

import 'package:flutter/material.dart';

class WelcomePageData extends ChangeNotifier {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  void onPageChanged(int index) {
    _currentPage = index;
    notifyListeners();
  }

  PageController get pageController {
    return _pageController;
  }

  int get currentPage {
    return _currentPage;
  }

  void setCurrentPage(int num) {
    _currentPage = num;
    notifyListeners();
  }

  void incrementCurrentPage() {
    _currentPage++;
    notifyListeners();
  }
}
