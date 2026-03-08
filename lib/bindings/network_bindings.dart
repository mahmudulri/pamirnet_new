import 'package:get/get.dart';
import '../controllers/country_list_controller.dart';
import '../controllers/district_controller.dart';
import '../controllers/province_controller.dart';

class NetworkBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CountryListController>(() => CountryListController());
    Get.lazyPut<ProvinceController>(() => ProvinceController());
    Get.lazyPut<DistrictController>(() => DistrictController());
  }
}
