import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../pages/homepages.dart';
import '../pages/network.dart';
import '../pages/orders.dart';
import '../pages/transaction_type.dart';
import '../pages/transactions.dart';

class Mypagecontroller extends GetxController {
  /// Navigation stack
  RxList<Widget> pageStack = <Widget>[Homepages()].obs;

  /// Bottom navigation selected index
  RxInt lastSelectedIndex = 0.obs;

  /// Main (bottom nav) pages
  final List<Widget> mainPages = [
    Homepages(), // index 0
    Transactions(), // index 1
    Orders(), // index 2
    Network(), // index 3
  ];

  Function(int)? updateIndexCallback;

  void setUpdateIndexCallback(Function(int) callback) {
    updateIndexCallback = callback;
  }

  /// 🔹 Cleaner helper getters
  bool get isHomeSelected => lastSelectedIndex.value == 0;

  bool get isRootPage => pageStack.length == 1;

  bool get isHomeRoot => isHomeSelected && isRootPage;

  /// 🔹 Change page handler
  void changePage(Widget page, {bool isMainPage = true}) {
    if (isMainPage) {
      // Update bottom nav index
      lastSelectedIndex.value = mainPages.indexWhere(
        (element) => element.runtimeType == page.runtimeType,
      );

      // Reset navigation stack for main page
      pageStack.value = [page];
    } else {
      // Push sub page
      pageStack.add(page);
    }

    // Notify bottom navigation (if needed)
    updateIndexCallback?.call(isMainPage ? lastSelectedIndex.value : -1);
  }

  /// 🔹 Back navigation handler
  bool goBack() {
    if (pageStack.length > 1) {
      pageStack.removeLast();
      return false; // Don't exit app
    }
    return true; // Exit app
  }

  /// 🔹 Navigate using bottom nav index
  void goToMainPageByIndex(int index) {
    lastSelectedIndex.value = index;
    pageStack.value = [mainPages[index]];
    updateIndexCallback?.call(index);
  }
}
