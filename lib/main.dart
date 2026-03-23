import 'package:ar_chem_lab/config/di/di.dart';
import 'package:ar_chem_lab/core/routes/app_route_generator.dart';
import 'package:ar_chem_lab/core/theme/app_theme.dart';
import 'package:ar_chem_lab/presentation/auth/cubit/auth_view_model.dart';
import 'package:ar_chem_lab/core/services/app_initialization_service.dart';
import 'package:ar_chem_lab/core/services/initial_route_resolver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ar_chem_lab/presentation/chat_bot/cubit/chat_cubit.dart';

void main() async {
  // Initialize the application
  await AppInitializationService.initialize();

  // Determine the initial route based on app state
  final initialRoute = await InitialRouteResolver.getInitialRoute();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<AuthViewModel>()),
        BlocProvider(create: (context) => getIt<ChatCubit>()),
      ],
      child: MyApp(initialRoute: initialRoute),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chem Lab',
        initialRoute: initialRoute,
        onGenerateRoute: AppRouteGenerator.generateRoute,
        theme: AppTheme.darkTheme,
      ),
    );
  }
}
