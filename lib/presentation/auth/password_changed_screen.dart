import 'package:ar_chem_lab/core/constants/app_assets.dart';
import 'package:ar_chem_lab/core/routes/app_routes.dart';
import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:ar_chem_lab/core/theme/app_gradients.dart';
import 'package:ar_chem_lab/core/theme/app_styles.dart';
import 'package:ar_chem_lab/presentation/auth/widgets/auth_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PasswordChangedScreen extends StatelessWidget {
  const PasswordChangedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: AppGradients.primary(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.midnightBlue, AppColors.royalBlue],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- SUCCESS IMAGE ---
                Image.asset(
                  AppAssets.successMarkImage,
                  width: 150.w,
                  height: 150.h,
                ),
                SizedBox(height: 40.h),

                // --- HEADER SECTION ---
                _buildHeader(),
                SizedBox(height: 40.h),

                // --- ACTION BUTTON ---
                _buildBackToLoginButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- WIDGET EXTRACTS ---

  /// Builds the success message title and subtitle
  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          "Password Changed!",
          style: AppStyles.bold32whitePrimary,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16.h),
        Text(
          "Your password has been changed successfully.",
          style: AppStyles.regular12whiteSecondary.copyWith(fontSize: 14.sp),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Builds the stylized "Back to Login" button
  Widget _buildBackToLoginButton(BuildContext context) {
    return AuthButton(
      text: "Back to Login",
      onPressed: () {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.loginScreen,
          (route) => false,
        );
      },
    );
  }
}
