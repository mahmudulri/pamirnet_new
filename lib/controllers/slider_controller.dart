import 'package:get/get.dart';
import 'package:pamirnet/models/slider_model.dart';
import 'package:pamirnet/services/slider_service.dart';

class SliderController extends GetxController {
  @override
  void onInit() {
    fetchSliderData();
    super.onInit();
  }

  var isLoading = false.obs;

  var allsliderlist = SliderModel().obs;

  void fetchSliderData() async {
    try {
      isLoading(true);
      await SlidersApi().fetchSliders().then((value) {
        allsliderlist.value = value;

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}
