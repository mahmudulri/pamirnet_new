import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pamirnet/controllers/dashboard_controller.dart';
import 'package:pamirnet/controllers/sign_in_controller.dart';
import 'package:pamirnet/global_controller/page_controller.dart';
import 'package:pamirnet/global_controller/languages_controller.dart';
import 'package:pamirnet/routes/routes.dart';

import 'package:pamirnet/screens/sign_up_screen.dart';
import 'package:pamirnet/utils/colors.dart';
import 'package:pamirnet/widgets/authtextfield.dart';
import 'package:pamirnet/widgets/drawer.dart';
import 'package:pamirnet/widgets/social_button.dart';
import 'package:pamirnet/widgets/socialbuttonbox.dart';

import '../global_controller/font_controller.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  LanguagesController languagesController = Get.put(LanguagesController());
  // final Mypagecontroller mypagecontroller = Get.find();

  // final Mypagecontroller mypagecontroller = Get.find();

  final signInController = Get.find<SignInController>();

  final dashboardController = Get.find<DashboardController>();

  final box = GetStorage();

  final String phoneNumber = "+93799033223";

  Future<bool> showExitPopup() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(languagesController.tr("EXIT_APP")),
        content: Text(languagesController.tr("DO_YOU_WANT_TO_EXIT_APP")),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(languagesController.tr("NO")),
          ),
          ElevatedButton(
            onPressed: () {
              exit(0);
            },
            child: Text(languagesController.tr("YES")),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: BoxDecoration(gradient: AppColors.primaryGradient),
          height: screenHeight,
          width: screenWidth,
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 10,
                      right: 0,
                      left: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 50,
                            backgroundImage: AssetImage(
                              "assets/icons/logo.png",
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Positioned(
                    //   bottom: 40,
                    //   right: 0,
                    //   left: 0,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       Text(
                    //         "Pamir Net",
                    //         style: TextStyle(
                    //           fontSize: 30,
                    //           fontWeight: FontWeight.bold,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Positioned(
                      bottom: 100,
                      right: 20,
                      left: 300,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(6),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                    languagesController.tr("LANGUAGES"),
                                  ),
                                  content: SizedBox(
                                    height: 350,
                                    width: MediaQuery.of(context).size.width,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: languagesController
                                          .alllanguagedata
                                          .length,
                                      itemBuilder: (context, index) {
                                        final data = languagesController
                                            .alllanguagedata[index];

                                        return GestureDetector(
                                          onTap: () {
                                            final languageName = data["name"]
                                                .toString();

                                            final matched = languagesController
                                                .alllanguagedata
                                                .firstWhere(
                                                  (lang) =>
                                                      lang["name"] ==
                                                      languageName,
                                                  orElse: () => {
                                                    "isoCode": "en",
                                                    "direction": "ltr",
                                                  },
                                                );

                                            final languageISO =
                                                matched["isoCode"]!;
                                            final languageDirection =
                                                matched["direction"]!;

                                            // Save & apply
                                            languagesController.changeLanguage(
                                              languageName,
                                            );
                                            box.write("language", languageName);
                                            box.write(
                                              "direction",
                                              languageDirection,
                                            );

                                            // Map iso → Locale
                                            Locale locale;
                                            switch (languageISO) {
                                              case "fa":
                                                locale = const Locale(
                                                  "fa",
                                                  "IR",
                                                );
                                                break;
                                              case "ar":
                                                locale = const Locale(
                                                  "ar",
                                                  "AE",
                                                );
                                                break;
                                              case "ps":
                                                locale = const Locale(
                                                  "ps",
                                                  "AF",
                                                );
                                                break;
                                              case "tr":
                                                locale = const Locale(
                                                  "tr",
                                                  "TR",
                                                );
                                                break;
                                              case "bn":
                                                locale = const Locale(
                                                  "bn",
                                                  "BD",
                                                );
                                                break;
                                              case "en":
                                              default:
                                                locale = const Locale(
                                                  "en",
                                                  "US",
                                                );
                                            }

                                            setState(() {
                                              EasyLocalization.of(
                                                context,
                                              )!.setLocale(locale);
                                            });

                                            Navigator.pop(context);
                                            debugPrint(
                                              "🌐 Language: $languageName ($languageISO), dir: $languageDirection",
                                            );
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(bottom: 5),
                                            height: 45,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                width: 1,
                                                color: Colors.grey.shade300,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10,
                                            ),
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              data["fullname"].toString(),
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(
                                  () => Text(
                                    languagesController.selectedlan.value,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.language,
                                  color: Colors.white,
                                  size: 20,
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
              Expanded(
                flex: 9,
                child: Obx(
                  () => Container(
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      border: Border(
                        top: BorderSide(
                          width: 3,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: ListView(
                          padding: EdgeInsets.all(0),
                          children: [
                            SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  languagesController.tr("WELCOME_TO_pamirnet"),
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenHeight * 0.025,
                                    fontFamily:
                                        "Btitrbold", //  need condition when persian
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  languagesController.tr(
                                    "ENTER_YOUR_LOGIN_INFO",
                                  ),
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: screenHeight * 0.020,
                                    fontFamily:
                                        box.read("language").toString() == "Fa"
                                        ? Get.find<FontController>().currentFont
                                        : null,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Authtextfield(
                              hinttext: languagesController.tr("USERNAME"),
                              controller: signInController.usernameController,
                            ),
                            SizedBox(height: 5),
                            Authtextfield(
                              hinttext: languagesController.tr("PASSWORD"),
                              controller: signInController.passwordController,
                            ),
                            // SizedBox(
                            //   height: 8,
                            // ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.end,
                            //   children: [
                            //     Text(
                            //       languagesController.tr("FORGOT_YOUR_PASSWORD"),
                            //       style: TextStyle(
                            //         color: Colors.grey.shade500,
                            //         fontSize: screenHeight * 0.016,
                            //         fontFamily: box.read("language").toString() ==
                            //                 "Fa"
                            //             ? Get.find<FontController>().currentFont
                            //             : null,
                            //       ),
                            //     ),
                            //     SizedBox(
                            //       width: 10,
                            //     ),
                            //     Text(
                            //       languagesController.tr("PASSWORD_RECOVERY"),
                            //       style: TextStyle(
                            //         color: Color(0xff1890FF),
                            //         fontSize: screenHeight * 0.017,
                            //         fontWeight: FontWeight.bold,
                            //         fontFamily: box.read("language").toString() ==
                            //                 "Fa"
                            //             ? Get.find<FontController>().currentFont
                            //             : null,
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            SizedBox(height: 15),
                            Obx(
                              () => GestureDetector(
                                onTap: signInController.isLoading.value
                                    ? null
                                    : () async {
                                        if (signInController
                                                .usernameController
                                                .text
                                                .trim()
                                                .isEmpty ||
                                            signInController
                                                .passwordController
                                                .text
                                                .isEmpty) {
                                          Get.snackbar(
                                            "Oops!",
                                            "Fill the text fields",
                                          );
                                          return;
                                        }

                                        print("Attempting login...");

                                        await signInController.signIn();

                                        if (signInController
                                                .loginsuccess
                                                .value ==
                                            false) {
                                          await dashboardController
                                              .fetchDashboardData();
                                          Get.toNamed(basescreen);
                                        } else {
                                          print(
                                            "Navigation conditions not met.",
                                          );
                                        }
                                      },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  height: screenHeight * 0.060,
                                  width: screenWidth,
                                  decoration: BoxDecoration(
                                    // Loading হলে grey
                                    color: signInController.isLoading.value
                                        ? Colors.grey.shade400
                                        : AppColors.primaryColor,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Center(
                                    child: signInController.isLoading.value
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const SizedBox(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2.5,
                                                      color: Colors.white,
                                                    ),
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                languagesController.tr(
                                                  "PLEASE_WAIT",
                                                ),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      screenHeight * 0.020,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily:
                                                      box
                                                              .read("language")
                                                              .toString() ==
                                                          "Fa"
                                                      ? Get.find<
                                                              FontController
                                                            >()
                                                            .currentFont
                                                      : null,
                                                ),
                                              ),
                                            ],
                                          )
                                        : Text(
                                            languagesController.tr("LOGIN"),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: screenHeight * 0.024,
                                              fontWeight: FontWeight.bold,
                                              fontFamily:
                                                  box
                                                          .read("language")
                                                          .toString() ==
                                                      "Fa"
                                                  ? Get.find<FontController>()
                                                        .currentFont
                                                  : null,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),

                            GestureDetector(
                              onTap: () {
                                Get.to(() => SignUpScreen());
                              },
                              child: Container(
                                height: screenHeight * 0.060,
                                width: screenWidth,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: AppColors.primaryColor,
                                  ),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Center(
                                  child: Obx(
                                    () => Text(
                                      languagesController.tr("REGISTER"),
                                      style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontSize: screenHeight * 0.024,
                                        fontWeight: FontWeight.bold,
                                        fontFamily:
                                            box.read("language").toString() ==
                                                "Fa"
                                            ? Get.find<FontController>()
                                                  .currentFont
                                            : null,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // SocialButton(),

                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     Text(
                            //       languagesController
                            //           .tr("HAVE_NOT_REGISTERED_YET"),
                            //       style: TextStyle(
                            //         color: Colors.grey.shade500,
                            //         fontSize: screenHeight * 0.018,
                            //         fontFamily: box.read("language").toString() ==
                            //                 "Fa"
                            //             ? Get.find<FontController>().currentFont
                            //             : null,
                            //       ),
                            //     ),
                            //     SizedBox(
                            //       width: 10,
                            //     ),
                            //     GestureDetector(
                            //       onTap: () {},
                            //       child: Text(
                            //         languagesController.tr("REGISTER"),
                            //         style: TextStyle(
                            //           color: Color(0xff1890FF),
                            //           fontSize: screenHeight * 0.018,
                            //           fontWeight: FontWeight.bold,
                            //           fontFamily:
                            //               box.read("language").toString() == "Fa"
                            //                   ? Get.find<FontController>()
                            //                       .currentFont
                            //                   : null,
                            //         ),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            SizedBox(height: 20),
                            Container(
                              height: 60,
                              width: screenWidth,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      whatsapp();
                                    },
                                    child: Image.asset(
                                      "assets/icons/whatsapp2.png",
                                      height: 50,
                                    ),
                                  ),
                                  SizedBox(width: 50),
                                  GestureDetector(
                                    onTap: () {
                                      showSocialPopup(context);
                                    },
                                    child: Image.asset(
                                      "assets/icons/social-media.png",
                                      height: 40,
                                    ),
                                  ),
                                  SizedBox(width: 50),
                                  GestureDetector(
                                    onTap: () {
                                      _makePhoneCall(phoneNumber);
                                    },
                                    child: Image.asset(
                                      "assets/icons/telephone.png",
                                      height: 40,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _makePhoneCall(String number) async {
  final Uri url = Uri(scheme: 'tel', path: number);
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}

class languageBox extends StatelessWidget {
  languageBox({super.key, this.lanName, this.onpressed});
  final String? lanName;
  final VoidCallback? onpressed;

  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: GestureDetector(
        onTap: onpressed,
        child: Container(
          margin: EdgeInsets.only(bottom: 6),
          height: 40,
          width: screenWidth,
          decoration: BoxDecoration(
            color: Colors.lightBlue,
            border: Border.all(width: 1, color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              lanName.toString(),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontFamily: box.read("language").toString() == "Fa"
                    ? Get.find<FontController>().currentFont
                    : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
