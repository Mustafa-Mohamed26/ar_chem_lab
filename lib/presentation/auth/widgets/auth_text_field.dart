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
  final FormFieldValidator<String>? validator;

  // --- CONSTRUCTOR ---
  const AuthTextField({
    super.key,
    required this.hintText,
    this.isPassword = false,
    this.controller,
    this.validator,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  // --- STATE VARIABLES ---
  bool _obscureText = true;
  String? _errorText;

  // --- BUILD METHOD ---
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientBorderContainer(
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
            child: TextFormField(
              controller: widget.controller,
              validator: (value) {
                final error = widget.validator?.call(value);
                if (error != _errorText) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      setState(() {
                        _errorText = error;
                      });
                    }
                  });
                }
                return error;
              },
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
                errorStyle: const TextStyle(height: 0, fontSize: 0),
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
        ),
        if (_errorText != null)
          Padding(
            padding: EdgeInsets.only(top: 5.h, left: 5.w),
            child: Text(
              _errorText!,
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}
