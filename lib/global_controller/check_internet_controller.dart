import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  final RxBool hasinternet = true.obs;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  bool _dialogShowing = false;

  @override
  void onInit() {
    super.onInit();

    _checkInitialConnection();

    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      _updateConnectionStatus(results);
    });
  }

  Future<void> _checkInitialConnection() async {
    try {
      final List<ConnectivityResult> results = await _connectivity
          .checkConnectivity();

      _updateConnectionStatus(results);
    } catch (e) {
      debugPrint('Initial connectivity check error: $e');
    }
  }

  void _updateConnectionStatus(List<ConnectivityResult> connectivityResults) {
    final bool isDisconnected =
        connectivityResults.isEmpty ||
        connectivityResults.contains(ConnectivityResult.none);

    if (isDisconnected) {
      hasinternet.value = false;

      _showNoInternetDialog();
    } else {
      hasinternet.value = true;

      _closeNoInternetDialog();
    }
  }

  void _showNoInternetDialog() {
    if (_dialogShowing) {
      return;
    }

    // GetMaterialApp / Navigator ready হওয়ার পরে dialog দেখাবে
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.context == null) {
        return;
      }

      if (hasinternet.value == false &&
          Get.isDialogOpen != true &&
          !_dialogShowing) {
        _dialogShowing = true;

        Get.dialog(
          PopScope(
            canPop: false,
            child: const AlertDialog(
              title: Text('No Internet Connection'),
              content: Text('Please connect to the internet.'),
            ),
          ),
          barrierDismissible: false,
        ).whenComplete(() {
          _dialogShowing = false;
        });
      }
    });
  }

  void _closeNoInternetDialog() {
    if (Get.context == null) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isDialogOpen == true) {
        Get.back();
      }

      _dialogShowing = false;
    });
  }

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    super.onClose();
  }
}
