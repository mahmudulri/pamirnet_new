import 'package:get/get.dart';

import '../models/country_list_model.dart';
import '../models/new_service_model.dart';
import '../services/category_service.dart';

class CategorisListController extends GetxController {
  var isLoading = false.obs;
  var allcategorieslist = NewServiceCatModel().obs;

  // Variables to store country and category data
  var countryList = [].obs;
  var categoryList = [].obs;

  // Variable to store combined data
  var combinedList = [].obs;

  // Sets to track unique IDs
  var countryIds = <String>{};
  var categoryIds = <String>{};
  // final List<Map<String, dynamic>> nonsocialArray = -[];

  void fetchcategories() async {
    try {
      isLoading(true);
      await CategoriesListApi().fetchcategoriesList().then((value) {
        allcategorieslist.value = value;

        // Temporary map to store data grouped by country
        final Map<String, dynamic> countryData = {};

        for (var category in value.data!.servicecategories ?? []) {
          final String? type = category.type;
          final String? categoryId = category.id.toString();
          final String? categoryName = category.categoryName;

          // Ensure necessary values are not null
          if (type != null &&
              type != "social" &&
              categoryId != null &&
              categoryName != null) {
            for (var service in category.services ?? []) {
              final String? country = service.company?.country?.countryName;
              final String? countryId = service.company?.countryId.toString();
              final String? countryImage =
                  service.company?.country?.countryFlagImageUrl;
              final String? phoneNumberLength = service
                  .company
                  ?.country
                  ?.phoneNumberLength
                  .toString();

              if (country != null && countryId != null) {
                countryData.putIfAbsent(country, () {
                  return {
                    'countryName': country,
                    'countryId': countryId.toString(),
                    'countryImage': countryImage,
                    'phoneNumberLength': phoneNumberLength.toString(),
                    'categories':
                        <Map<String, dynamic>>[], // Initialize category list
                    'categorySet':
                        <String>{}, // Set to track unique category IDs
                  };
                });

                // Add the category to the country's category list if not already present
                if (!countryData[country]['categorySet'].contains(
                  categoryId.toString(),
                )) {
                  countryData[country]['categories'].add({
                    'categoryId': categoryId.toString(),
                    'categoryName': categoryName,
                  });

                  // Track the category in the set
                  countryData[country]['categorySet'].add(
                    categoryId.toString(),
                  );
                }
              }
            }
          }
        }

        combinedList.value = countryData.values.map((country) {
          country.remove(
            'categorySet',
          ); // Remove the temporary set before saving
          return country;
        }).toList();

        // Print the JSON output
        print('Combined List: ${combinedList.toJson()}');

        isLoading(false);
      });
    } catch (e) {
      print("Error fetching categories: ${e.toString()}");
      isLoading(false);
    }
  }
}
