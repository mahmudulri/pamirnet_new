import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pamirnet/widgets/ktext.dart';

import '../controllers/delete_notification_controller.dart';
import '../controllers/mark_as_read_controller.dart';
import '../global_controller/languages_controller.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({
    super.key,
    this.notificationID,
    this.title,
    this.message,
    this.status,
  });

  final notificationID;
  final title;
  final message;
  final status;

  MarkAsReadController markAsReadController = Get.put(MarkAsReadController());

  LanguagesController languagesController = Get.put(LanguagesController());
  DeleteNotificationController deleteNotificationController = Get.put(
    DeleteNotificationController(),
  );

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0BCF3), Color(0xFF7EE7EE)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                KText(
                  text: languagesController.tr("NOTIFICATION_DETAILS"),

                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),

            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon Header
                        Center(
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFFE0BCF3), Color(0xFF7EE7EE)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFFE0BCF3).withOpacity(0.3),
                                  blurRadius: 15,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.notifications_active,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        if (notificationID != null)
                          Center(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xFFE0BCF3).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'ID: ${notificationID.toString()}',
                                style: TextStyle(
                                  color: Color(0xFF8B5CB5),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        SizedBox(height: 10),

                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFFE0BCF3).withOpacity(0.1),
                                Color(0xFF7EE7EE).withOpacity(0.1),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  KText(
                                    text: languagesController.tr("TITLE"),

                                    color: Color(0xFF8B5CB5),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              KText(text: title?.toString() ?? 'No title'),
                            ],
                          ),
                        ),

                        SizedBox(height: 20),

                        // Message Section
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.grey[200]!,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  KText(
                                    text: languagesController.tr("MESSAGE"),

                                    color: Color(0xFF4DB8BE),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              KText(text: message?.toString() ?? 'No message'),
                            ],
                          ),
                        ),
                        SizedBox(height: 50),
                        Row(
                          children: [
                            Expanded(
                              child: Obx(
                                () =>
                                    markAsReadController.isLoading.value ==
                                        false
                                    ? ElevatedButton.icon(
                                        onPressed: () {
                                          status.toString() == "Read"
                                              ? markAsReadController.markasread(
                                                  notificationID.toString(),
                                                )
                                              : print("object");
                                        },
                                        icon: Icon(Icons.check_circle_outline),
                                        label: Text(
                                          languagesController.tr(
                                            "MARK_AS_READ",
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              status.toString() == "Read"
                                              ? Color(0xFF8B5CB5)
                                              : Colors.grey,
                                          foregroundColor: Colors.white,
                                          padding: EdgeInsets.symmetric(
                                            vertical: 14,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          elevation: 0,
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          KText(
                                            text: languagesController.tr(
                                              "PLEASE_WAIT",
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
