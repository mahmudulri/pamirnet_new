import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../models/new_service_model.dart';
import '../utils/api_endpoints.dart';

class CategoriesListApi {
  final box = GetStorage();
  Future<NewServiceCatModel> fetchcategoriesList() async {
    final url = Uri.parse(
      ApiEndPoints.baseUrl + ApiEndPoints.otherendpoints.servicecategories,
    );
    print(url);

    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ${box.read("userToken")}'},
    );

    if (response.statusCode == 200) {
      // print(response.body.toString());
      final categorieslistModel = NewServiceCatModel.fromJson(
        json.decode(response.body),
      );
      // print(categorieslistModel.toJson());

      return categorieslistModel;
    } else {
      throw Exception('Failed to fetch gateway');
    }
  }
}
