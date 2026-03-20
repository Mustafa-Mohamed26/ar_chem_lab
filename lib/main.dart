import 'package:ar_chem_lab/config/bloc_observer.dart';
import 'package:ar_chem_lab/config/di/di.dart';
import 'package:ar_chem_lab/core/routes/app_routes.dart';
import 'package:ar_chem_lab/core/routes/app_route_generator.dart';
import 'package:ar_chem_lab/core/theme/app_theme.dart';
import 'package:ar_chem_lab/presentation/auth/cubit/auth_view_model.dart';
import 'package:ar_chem_lab/core/services/onboarding_service.dart';
import 'package:ar_chem_lab/core/services/view_history_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await ScreenUtil.ensureScreenSize();
  configureDependencies();
  await Future.wait([
    ViewHistoryService().loadHistory(),
    OnboardingService().loadOnboardingStatus(),
  ]);
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<AuthViewModel>()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Chem Lab',
          initialRoute: OnboardingService().isOnboardingComplete
              ? AppRoutes.homeScreen
              : AppRoutes.onboarding,
          onGenerateRoute: AppRouteGenerator.generateRoute,
          theme: AppTheme.darkTheme,
        ),
      ),
    );
  }
}
