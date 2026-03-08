import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../global_controller/languages_controller.dart';

Future<void> _launchUrl(String url) async {
  final Uri uri = Uri.parse(url);

  try {
    // অ্যাপ দিয়ে ওপেন করার চেষ্টা
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      // ব্রাউজার fallback
      if (!await launchUrl(uri, mode: LaunchMode.platformDefault)) {
        throw 'Could not launch $url';
      }
    }
  } catch (e) {
    debugPrint("Launch error: $e");
  }
}

LanguagesController languagesController = Get.put(LanguagesController());
void showSocialPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext ctx) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(languagesController.tr("CONNECT_WITH_US")),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.telegram, color: Colors.white),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: Size(double.infinity, 45),
              ),
              label: Text("Telegram"),
              onPressed: () => _launchUrl("https://t.me/Tak_Telecom"),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              icon: Icon(Icons.facebook, color: Colors.white),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                minimumSize: Size(double.infinity, 45),
              ),
              label: Text("Facebook"),
              onPressed: () =>
                  _launchUrl("https://www.facebook.com/mahmudulrirz"),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              icon: Icon(Icons.camera_alt, color: Colors.white),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                minimumSize: Size(double.infinity, 45),
              ),
              label: Text("Instagram"),
              onPressed: () => _launchUrl("https://instagram.com/tak_telecom"),
            ),
            // SizedBox(height: 10),
            // ElevatedButton.icon(
            //   icon: Icon(FontAwesomeIcons.whatsapp, color: Colors.white),
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.green,
            //     minimumSize: Size(double.infinity, 45),
            //   ),
            //   label: Text("WhatsApp"),
            //   onPressed: () => _launchUrl("https://wa.me/989032926310"),
            // ),
          ],
        ),
      );
    },
  );
}
