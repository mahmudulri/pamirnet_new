import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../models/currency_model.dart';
import '../services/currency_service.dart';
import '../global_controller/conversation_controller.dart';

class CurrencyController extends GetxController {
  final ConversationController conversationController = Get.put(
    ConversationController(),
  );

  var isLoading = false.obs;
  final box = GetStorage();

  var allcurrency = CurrencyModel().obs;

  @override
  void onInit() {
    fetchCurrency();
    super.onInit();
  }

  void fetchCurrency() async {
    try {
      isLoading(true);
      final value = await CurrencyApi().fetchcurrency();
      allcurrency.value = value;

      if (value.data?.currencies != null) {
        // শুধুমাত্র যাদের country null না তাদের ফিল্টার করা হচ্ছে
        final validCurrencies = value.data!.currencies!
            .where((c) => c.country != null)
            .toList();

        conversationController.currencies.assignAll(validCurrencies);

        // GetStorage থেকে সেভ করা কোড পড়া হচ্ছে
        String codeFromBox = box.read("currency_code") ?? "";

        if (validCurrencies.isNotEmpty) {
          final matched = validCurrencies.firstWhereOrNull(
            (c) => c.code == codeFromBox,
          );

          if (matched != null) {
            // ম্যাচিড কারেন্সির ডাটা সেট করা
            conversationController.selectedCurrency.value = matched.code ?? "";
            conversationController.currencyRate.value =
                double.tryParse(matched.exchangeRatePerUsd ?? "1") ?? 1;

            // 🔥 এখানে আপনার কাঙ্ক্ষিত পতাকার URL টি সেট করা হচ্ছে
            conversationController.selectedCountryFlag.value =
                matched.country?.countryFlagImageUrl ?? "";
          } else {
            // যদি ম্যাচ না করে, তবে প্রথমটি ডিফোল্ট হিসেবে সেট করা
            final firstCurrency = validCurrencies.first;
            conversationController.selectedCurrency.value =
                firstCurrency.code ?? "";
            conversationController.currencyRate.value =
                double.tryParse(firstCurrency.exchangeRatePerUsd ?? "1") ?? 1;

            // প্রথমটির পতাকা সেট করা
            conversationController.selectedCountryFlag.value =
                firstCurrency.country?.countryFlagImageUrl ?? "";
          }
        }
      }
    } catch (e) {
      print("Error fetching currency: $e");
    } finally {
      isLoading(false);
    }
  }

  /// 🔥 ড্রপডাউন পরিবর্তন করলে এই মেথডটি কল হবে
  void onCurrencySelected(Currency currency) {
    if (currency.code != null) {
      conversationController.selectedCurrency.value = currency.code!;
      conversationController.currencyRate.value =
          double.tryParse(currency.exchangeRatePerUsd ?? "1") ?? 1;

      // 🔥 সিলেক্ট করা কারেন্সির পতাকা আপডেট
      conversationController.selectedCountryFlag.value =
          currency.country?.countryFlagImageUrl ?? "";

      box.write("currency_code", currency.code);
    }
  }
}
