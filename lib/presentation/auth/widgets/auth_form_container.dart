import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:ar_chem_lab/presentation/auth/widgets/gradient_border_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthFormContainer extends StatelessWidget {
  final Widget child;

  const AuthFormContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GradientBorderContainer(
      borderWidth: 1.5.w,
      borderRadius: 30.r,
      innerBackgroundColor: AppColors.midnightBlue.withValues(alpha: 0.85),
      gradient: const LinearGradient(
        colors: [AppColors.electricBlue, AppColors.skyBlue],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
        child: child,
      ),
    );
  }
}
