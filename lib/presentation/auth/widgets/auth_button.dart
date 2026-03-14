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
  final bool isLoading;

  const AuthButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.height,
    this.isLoading = false,
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
      child: SizedBox(
        height: height ?? 50.h,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : Text(text, style: AppStyles.bold20whitePrimary),
        ),
      ),
    );
  }
}
