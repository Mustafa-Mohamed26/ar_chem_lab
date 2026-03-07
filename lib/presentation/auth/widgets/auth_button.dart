import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:ar_chem_lab/core/theme/app_gradients.dart';
import 'package:ar_chem_lab/core/theme/app_styles.dart';
import 'package:ar_chem_lab/presentation/auth/widgets/gradient_border_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? height;

  const AuthButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GradientBorderContainer(
      borderWidth: 1.5.w,
      borderRadius: 8.r,
      innerGradientBackground: AppGradients.primary(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.midnightBlue, AppColors.midnightBlue],
      ),
      gradient: const LinearGradient(
        colors: [AppColors.electricBlue, AppColors.skyBlue],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      child: Container(
        height: height ?? 50.h,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.midnightBlue.withOpacity(0.3),
              blurRadius: 10.r,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          child: Text(text, style: AppStyles.bold20whitePrimary),
        ),
      ),
    );
  }
}
