import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:ar_chem_lab/core/theme/app_styles.dart';
import 'package:ar_chem_lab/core/routes/app_routes.dart';
import 'package:ar_chem_lab/presentation/widget/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({super.key});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.length == 1 && index < 3) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "OTP Verification",
                        style: AppStyles.bold24whiteOrbitron,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        "Enter the verification code we just sent on your email address.",
                        style: AppStyles.regular13interLightGray,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 48.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                          4,
                          (index) => _buildOTPBox(index),
                        ),
                      ),
                      SizedBox(height: 48.h),
                      AppButton(
                        text: "Verify",
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.createNewPasswordScreen);
                        },
                      ),
                      SizedBox(height: 32.h),
                      _buildResendFooter(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOTPBox(int index) {
    return Container(
      width: 64.w,
      height: 64.w,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8F9),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Center(
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          onChanged: (value) => _onChanged(value, index),
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(1),
          ],
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.midnightBlue,
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            counterText: "",
          ),
        ),
      ),
    );
  }

  Widget _buildResendFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Didn't received code? ",
          style: AppStyles.regular13interLightGray,
        ),
        GestureDetector(
          onTap: () {
            // Handle resend
          },
          child: Text(
            "Resend",
            style: AppStyles.bold13interWhite,
          ),
        ),
      ],
    );
  }
}
