import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'app/data/lang/messages.dart';
import 'app/routes/app_pages.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      systemNavigationBarColor: Color(0xFFFFFFFF),
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "DRIVER",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      translations: Messages(),
      locale: const Locale('ar', 'SA'),
      fallbackLocale: const Locale('en', 'UN'),
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Changa Regular',
        backgroundColor: const Color(0xFFBF202E),
        primaryColor: const Color(0xFFBF202E),
        brightness: Brightness.light,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFFBF202E),
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F8FA),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          color: Colors.black,
          elevation: 0.1,
          titleTextStyle: TextStyle(
            fontFamily: 'Changa Regular',
            color: Colors.white,
            // fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xFFBF202E),
        ),
      ),
    ),
  );
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.ripple
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 70.0
    ..radius = 10.0
    ..progressColor = const Color(0xFFBF202E)
    ..backgroundColor = const Color(0xFFF7F8FA)
    ..indicatorColor = const Color(0xFFBF202E)
    ..textColor = const Color(0xFFBF202E)
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = false
    ..dismissOnTap = false;
}
