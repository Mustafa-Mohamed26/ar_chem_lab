import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:ar_chem_lab/core/theme/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthTextField extends StatefulWidget {
  // --- PROPERTIES ---
  final String? label;
  final String? hintText;
  final bool isPassword;
  final IconData? prefixIcon;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;

  // --- CONSTRUCTOR ---
  const AuthTextField({
    super.key,
    this.label,
     this.hintText,
    this.isPassword = false,
    this.prefixIcon,
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
        _buildLabel(),
        _buildInputBox(),
        _buildError(),
      ],
    );
  }

  // ------------------- Sections -------------------

  /// Field label displayed above the input
  Widget _buildLabel() {
    if (widget.label == null) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Text(
        widget.label!.toUpperCase(),
        style: AppStyles.semiBold12lightBlueInter,
      ),
    );
  }

  /// The main container for the text field
  Widget _buildInputBox() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkGray,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.secondaryDarkGray,
          width: 1.w,
        ),
      ),
      child: TextFormField(
        controller: widget.controller,
        validator: _validateField,
        obscureText: widget.isPassword ? _obscureText : false,
        style: AppStyles.semiBold16whiteInter,
        decoration: _buildInputDecoration(),
      ),
    );
  }

  /// Decoration with icons, hints, and padding
  InputDecoration _buildInputDecoration() {
    return InputDecoration(
      hintText: widget.hintText,
      hintStyle: AppStyles.semiBold16whiteInter,
      prefixIcon: _buildPrefixIcon(),
      suffixIcon: _buildSuffixIcon(),
      border: InputBorder.none,
      errorStyle: const TextStyle(height: 0, fontSize: 0),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 8.h,
      ),
    );
  }

  /// Icon at the start of the field
  Widget? _buildPrefixIcon() {
    if (widget.prefixIcon == null) return null;
    return Icon(
      widget.prefixIcon,
      color: AppColors.white,
      size: 20.sp,
    );
  }

  /// Toggle visibility icon for password fields
  Widget? _buildSuffixIcon() {
    if (!widget.isPassword) return null;
    return IconButton(
      icon: Icon(
        _obscureText ? Icons.visibility_off : Icons.visibility,
        color: AppColors.white,
      ),
      onPressed: () => setState(() => _obscureText = !_obscureText),
    );
  }

  /// Validation logic and state update
  String? _validateField(String? value) {
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
  }

  /// Displays the validation error text if present
  Widget _buildError() {
    if (_errorText == null) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(top: 5.h, left: 5.w),
      child: Text(
        _errorText!,
        style: TextStyle(
          color: Colors.redAccent,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
