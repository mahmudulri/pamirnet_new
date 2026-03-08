import 'package:get/get.dart';
import '../models/branch_model.dart';
import '../models/recharge_config_model.dart';
import '../services/branch_service.dart';
import '../services/recharge_config_service.dart';

class RechargeConfigController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    fetchrechargeConfig();
  }

  var isLoading = false.obs;

  var allsettings = RechargeConfigModel().obs;

  void fetchrechargeConfig() async {
    try {
      isLoading(true);
      await RechargeConfigApi().fetchconfig().then((value) {
        allsettings.value = value;

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}
