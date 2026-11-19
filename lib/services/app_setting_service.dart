import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/setting_model.dart';
import '../utils/api_endpoints.dart';

class AppSettingApi {
  Future<AppSettingModel> fetchAppSetting() async {
    final url = Uri.parse(ApiEndPoints.publicUrl + 'app-setting');

    final response = await http
        .get(url, headers: const {'Accept': 'application/json'})
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch app settings (${response.statusCode})');
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Invalid app settings response');
    }

    final appSettingModel = AppSettingModel.fromJson(decoded);

    if (appSettingModel.success != true) {
      throw Exception('App settings request was unsuccessful');
    }

    if (appSettingModel.data?.settings == null) {
      throw const FormatException('App settings data is missing');
    }

    return appSettingModel;
  }
}
