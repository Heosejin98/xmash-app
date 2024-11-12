import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xmash_app/config/routes/app_pages.dart';
import 'package:xmash_app/config/bindings/initial_binding.dart';
import 'package:xmash_app/core/theme/app_colors.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  // 로케일 데이터를 초기화합니다.
  await initializeDateFormatting('ko_KR', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Xmash',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          elevation: 0,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
        ),
      ),
      initialBinding: InitialBinding(),
      initialRoute: AppRoutes.home,
      getPages: AppPages.pages,
    );
  }
}
