import 'package:ar_chem_lab/config/bloc_observer.dart';
import 'package:ar_chem_lab/config/di/di.dart';
import 'package:ar_chem_lab/core/routes/app_routes.dart';
import 'package:ar_chem_lab/core/theme/app_theme.dart';
import 'package:ar_chem_lab/presentation/chat_bot/chat_bot_screen.dart';
import 'package:ar_chem_lab/presentation/history/history_screen.dart';
import 'package:ar_chem_lab/presentation/home/home_screen.dart';
import 'package:ar_chem_lab/presentation/onboarding/onboarding_screen.dart';
import 'package:ar_chem_lab/presentation/periodic_table/element_detail_screen.dart';
import 'package:ar_chem_lab/presentation/periodic_table/periodic_table_screen.dart';
import 'package:ar_chem_lab/core/services/onboarding_service.dart';
import 'package:ar_chem_lab/core/services/view_history_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await ScreenUtil.ensureScreenSize();
  configureDependencies();
  await Future.wait([
    ViewHistoryService().loadHistory(),
    OnboardingService().loadOnboardingStatus(),
  ]);
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
        initialRoute: OnboardingService().isOnboardingComplete
            ? AppRoutes.homeScreen
            : AppRoutes.onboarding,
        routes: {
          AppRoutes.onboarding: (context) => OnboardingScreen(),
          AppRoutes.homeScreen: (context) => HomeScreen(),
          AppRoutes.chatBotScreen: (context) => ChatBotScreen(),
          AppRoutes.historyScreen: (context) => HistoryScreen(),
          AppRoutes.periodicTableScreen: (context) => PeriodicTableScreen(),
          AppRoutes.elementDetailScreen: (context) => ElementDetailScreen(),
        },
        theme: AppTheme.darkTheme,
      ),
    );
  }
}
