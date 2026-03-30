import 'package:get/get.dart';
import 'package:pamirnet/models/new_service_model.dart';

import '../services/category_service.dart';

class NewCategorisListController extends GetxController {
  var isLoading = false.obs;
  var allcategorieslist = NewServiceCatModel().obs;

  // Combined data output
  var combinedList = [].obs;

  // Unique ID tracking
  var countryIds = <int>{};
  var categoryIds = <int>{};

  // Final structured list
  final List<Map<String, dynamic>> nonsocialArray = [];

  void fetchcategories() async {
    try {
      isLoading(true);
      final value = await CategoriesListApi().fetchcategoriesList();
      allcategorieslist.value = value;

      final Map<String, dynamic> nonsocial = {};

      for (var category in value.data?.servicecategories ?? []) {
        final String? type = category.type;
        final int? categoryId = category.id;
        final String? categoryName = category.categoryName;

        // Filter non-social categories only
        if (type != null &&
            type != "social" &&
            categoryId != null &&
            categoryName != null) {
          for (var service in category.services ?? []) {
            final String? countryName = service.company?.country?.countryName;
            final String? countryIdStr = service.company?.countryId;
            final int? countryId = int.tryParse(countryIdStr ?? '');
            final String? countryImage =
                service.company?.country?.countryFlagImageUrl;
            final String? phoneNumberLength =
                service.company?.country?.phoneNumberLength;

            if (countryName != null && countryId != null) {
              // Initialize entry for this country if not exists
              nonsocial.putIfAbsent(countryName, () {
                return {
                  'country_id': countryId,
                  'countryImage': countryImage,
                  'phone_number_length': phoneNumberLength,
                  'categories': <int, dynamic>{},
                };
              });

              // Insert category under the country's map
              final categories =
                  nonsocial[countryName]['categories'] as Map<int, dynamic>;
              categories.putIfAbsent(categoryId, () {
                return {
                  'categoryName': categoryName,
                  'country_id': countryId,
                  'countryImage': countryImage,
                  'phone_number_length': phoneNumberLength,
                };
              });
            }
          }
        }
      }

      // Convert map into final array structure
      nonsocial.forEach((countryName, countryValue) {
        final int? countryId = countryValue['country_id'];
        final String? countryImage = countryValue['countryImage'];
        final String? phoneNumberLength = countryValue['phone_number_length'];
        final Map<int, dynamic> categories =
            countryValue['categories'] as Map<int, dynamic>;

        categories.forEach((categoryId, categoryValue) {
          nonsocialArray.add({
            'countryName': countryName,
            'countryId': countryId,
            'countryImage': countryImage,
            'phoneNumberLength': phoneNumberLength,
            'categoryId': categoryId,
            'categoryName': categoryValue['categoryName'],
          });
        });
      });

      // Debug (optional)
      print("nonsocialArray count: ${nonsocialArray.length}");

      isLoading(false);
    } catch (e, stack) {
      print("❌ Error fetching categories: $e");
      print("❗ Stacktrace: $stack");
      isLoading(false);
    }
  }
}
