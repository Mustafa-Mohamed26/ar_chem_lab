import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:ar_chem_lab/core/theme/app_styles.dart';
import 'package:ar_chem_lab/presentation/auth/widgets/gradient_border_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthTextField extends StatefulWidget {
  // --- PROPERTIES ---
  final String hintText;
  final bool isPassword;
  final TextEditingController? controller;

  // --- CONSTRUCTOR ---
  const AuthTextField({
    super.key,
    required this.hintText,
    this.isPassword = false,
    this.controller,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  // --- STATE VARIABLES ---
  bool _obscureText = true;

  // --- BUILD METHOD ---
  @override
  Widget build(BuildContext context) {
    return GradientBorderContainer(
      borderWidth: 1.5.w,
      borderRadius: 8.r,
      innerBackgroundColor: AppColors.white,
      gradient: const LinearGradient(
        colors: [AppColors.electricBlue, AppColors.skyBlue],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.skyBlue.withOpacity(0.15),
              blurRadius: 10.r,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: TextField(
          controller: widget.controller,
          obscureText: widget.isPassword ? _obscureText : false,
          style: const TextStyle(
            color: AppColors.midnightBlue,
            fontFamily: 'NirmalaUI',
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: AppStyles.regular12graySecondary.copyWith(
              color: AppColors.lavender,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.lavender,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
