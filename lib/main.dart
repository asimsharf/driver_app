import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/data/lang/messages.dart';
import 'app/routes/app_pages.dart';

void main() {
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
        fontFamily: 'Brand Bold',
        primarySwatch: Colors.yellow,
      ),
    ),
  );
}
