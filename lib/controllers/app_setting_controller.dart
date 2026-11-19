import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../models/setting_model.dart';
import '../services/app_setting_service.dart';

class AppSettingController extends GetxController {
  final isLoading = false.obs;

  final alldata = AppSettingModel().obs;

  final error = RxnString();

  bool _hasLoaded = false;

  Settings? get settings => alldata.value.data?.settings;

  @override
  void onInit() {
    super.onInit();
    fetchAppSetting();
  }

  /// The initial response is reused until an explicit refresh.
  Future<void> fetchAppSetting({bool force = false}) async {
    if (isLoading.value || (_hasLoaded && !force)) return;

    isLoading.value = true;
    error.value = null;

    try {
      final result = await AppSettingApi().fetchAppSetting();

      alldata.value = result;
      _hasLoaded = true;
    } catch (e, stackTrace) {
      error.value = e.toString();

      debugPrint('App settings request failed: $e');

      debugPrintStack(stackTrace: stackTrace);
    } finally {
      isLoading.value = false;
    }
  }
}
