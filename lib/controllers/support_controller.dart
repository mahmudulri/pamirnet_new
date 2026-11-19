import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../models/support_model.dart';
import '../services/support_service.dart';

class SupportController extends GetxController {
  final isLoading = false.obs;
  final alldata = SupportModel().obs;
  final error = RxnString();

  bool _hasLoaded = false;

  @override
  void onInit() {
    super.onInit();
    fetchSupport();
  }

  /// The initial response is reused until an explicit refresh.
  Future<void> fetchSupport({bool force = false}) async {
    if (isLoading.value || (_hasLoaded && !force)) return;

    isLoading.value = true;
    error.value = null;

    try {
      final result = await SupportContactsApi().fetchSupport();
      alldata.value = result;
      _hasLoaded = true;
    } catch (e, stackTrace) {
      error.value = e.toString();
      debugPrint('Support contacts request failed: $e');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      isLoading.value = false;
    }
  }
}
