import 'package:ar_chem_lab/core/routes/app_routes.dart';
import 'package:ar_chem_lab/core/theme/app_theme.dart';
import 'package:ar_chem_lab/presentation/chat_bot/chat_bot_screen.dart';
import 'package:ar_chem_lab/presentation/history/history_screen.dart';
import 'package:ar_chem_lab/presentation/home/home_screen.dart';
import 'package:ar_chem_lab/presentation/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async{
  await ScreenUtil.ensureScreenSize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chem Lab',
        initialRoute: AppRoutes.onboarding,
        routes: {
          AppRoutes.onboarding: (context) =>  OnboardingScreen(),
          AppRoutes.homeScreen: (context) =>  HomeScreen(),
          AppRoutes.chatBotScreen: (context) =>  ChatBotScreen(),
          AppRoutes.historyScreen: (context) =>  HistoryScreen(),
        },
        theme: AppTheme.darkTheme,
      ),
    );
  }
}
