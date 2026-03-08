import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'controllers/network_checker.dart';
import 'global_controller/font_controller.dart';
import 'global_controller/time_zone_controller.dart';
import 'routes/routes.dart';
import 'splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await GetStorage.init();

  DependencyInjection.init();
  Get.put(TimeZoneController());
  Get.put(FontController());

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('fa', 'IR'),
        Locale('ar', 'AE'),
        Locale('ps', 'AF'),
        Locale('tr', 'TR'),
        Locale('bn', 'BD'),
      ],
      path: 'assets/langs',
      fallbackLocale: const Locale('en', 'US'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TimeZoneController timeZoneController = Get.find<TimeZoneController>();

  @override
  void initState() {
    super.initState();
    initTimezone();
  }

  void initTimezone() {
    Duration offset = DateTime.now().timeZoneOffset;

    timeZoneController.sign = offset.isNegative ? "-" : "+";
    timeZoneController.hour = offset.inHours.abs().toString().padLeft(2, '0');
    timeZoneController.minute = (offset.inMinutes.abs() % 60)
        .toString()
        .padLeft(2, '0');

    print(
      "Offset = ${timeZoneController.sign}${timeZoneController.hour}:${timeZoneController.minute}",
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: false),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      initialRoute: splash,
      getPages: myroutes,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.updateLocale(context.locale);
    });
  }
}
