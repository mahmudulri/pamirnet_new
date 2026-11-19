import 'dart:convert';

import 'package:http/http.dart' as http;
import '../models/support_model.dart';
import '../utils/api_endpoints.dart';

class SupportContactsApi {
  Future<SupportModel> fetchSupport() async {
    final url = Uri.parse(ApiEndPoints.publicUrl + "support-contacts");
    print(url);

    final response = await http
        .get(url, headers: const {'Accept': 'application/json'})
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to fetch support contacts (${response.statusCode})',
      );
    }

    final decoded = jsonDecode(response.body);
    print(response.body.toString());

    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Invalid support contacts response');
    }

    final supportModel = SupportModel.fromJson(decoded);

    if (supportModel.success != true) {
      throw Exception('Support request was unsuccessful');
    }

    return supportModel;
  }
}
