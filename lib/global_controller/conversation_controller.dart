import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/currency_model.dart';

class ConversationController extends GetxController {
  RxList<Currency> currencies = <Currency>[].obs;

  RxString selectedCurrency = "".obs;

  var selectedCountryFlag = "".obs;

  /// 🔥 MUST be reactive
  RxDouble currencyRate = 1.0.obs;

  /// existing fields (kept)
  double resellerRate = 0.0;
  RxDouble inputAmount = 0.0.obs;

  final box = GetStorage();

  void resetConversion() {
    inputAmount.value = 0.0;
    resellerRate = 0.0;
    currencies.clear();
  }

  /// 🔥 USD → Selected Currency
  double convertFromUsd(double usdAmount) {
    return usdAmount * currencyRate.value;
  }

  /// 🔁 existing AFN conversion logic (UNCHANGED)
  List<Map<String, dynamic>> getConvertedValues() {
    double afnAmount = inputAmount.value;

    final afnCurrency = currencies.firstWhereOrNull((c) => c.code == "AFN");
    if (afnCurrency == null || afnCurrency.exchangeRatePerUsd == null) {
      return [];
    }

    double? afnRate = double.tryParse(afnCurrency.exchangeRatePerUsd!);
    if (afnRate == null || afnRate <= 0) return [];

    double amountInUsd = afnAmount / afnRate;

    return currencies.where((c) => c.code != "AFN").map((c) {
      double rate = double.tryParse(c.exchangeRatePerUsd ?? "1") ?? 1;
      double converted = amountInUsd * rate;

      return {
        "name": c.name ?? "",
        "symbol": c.symbol ?? c.code,
        "code": c.code ?? "",
        "value": converted,
      };
    }).toList();
  }
}
