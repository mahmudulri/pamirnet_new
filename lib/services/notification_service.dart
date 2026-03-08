import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:pamirnet/models/notifications_model.dart';
import '../models/help_model.dart';
import '../models/service_model.dart';
import '../utils/api_endpoints.dart';

class NotificationApi {
  final box = GetStorage();
  Future<NotificationModel> fetchnotificationData() async {
    final url = Uri.parse("${ApiEndPoints.baseUrl}notifications");
    print(url);

    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ${box.read("userToken")}'},
    );

    if (response.statusCode == 200) {
      // print(response.body.toString());
      final notificationModel = NotificationModel.fromJson(
        json.decode(response.body),
      );

      return notificationModel;
    } else {
      throw Exception('Failed to fetch gateway');
    }
  }
}
