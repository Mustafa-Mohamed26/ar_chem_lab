import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:ar_chem_lab/core/theme/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;

  const AppButton({
    super.key,
    required this.text,
    required this.onTap,
    this.width,
    this.height,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 48.h,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.lightBlue,
          borderRadius: BorderRadius.circular(12.r),
          border: borderColor != null
              ? Border.all(color: borderColor!, width: 1)
              : null,
        ),
        child: Center(
          child: Text(
            text,
            style: AppStyles.bold18whiteSecondary.copyWith(
              color: textColor ?? AppColors.midnightBlue,
            ),
          ),
        ),
      ),
    );
  }
}
