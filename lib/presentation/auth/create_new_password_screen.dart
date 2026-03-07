import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:ar_chem_lab/core/theme/app_gradients.dart';
import 'package:ar_chem_lab/core/theme/app_styles.dart';
import 'package:ar_chem_lab/core/routes/app_routes.dart';
import 'package:ar_chem_lab/presentation/auth/widgets/auth_text_field.dart';
import 'package:ar_chem_lab/presentation/auth/widgets/auth_button.dart';
import 'package:ar_chem_lab/presentation/widget/gradient_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateNewPasswordScreen extends StatelessWidget {
  const CreateNewPasswordScreen({super.key});

  // --- MAIN BUILD METHOD ---
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 16.h),
                // --- BACK BUTTON ---
                Align(
                  alignment: Alignment.topRight,
                  child: const GradientBackButton(),
                ),
                SizedBox(height: 30.h),

                // --- HEADER SECTION ---
                _buildHeader(),
                SizedBox(height: 40.h),

                // --- FORM SECTION ---
                _buildForm(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- WIDGET EXTRACTS ---

  /// Builds the top title and subtitle of the screen
  Widget _buildHeader() {
    return Column(
      children: [
        Text("Create new password", style: AppStyles.bold32whitePrimary),
        SizedBox(height: 16.h),
        Text(
          "Your new password must be unique from those previously used.",
          style: AppStyles.regular12whiteSecondary.copyWith(fontSize: 14.sp),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Builds the form with the password fields and the reset button
  Widget _buildForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Input Fields
        const AuthTextField(hintText: "New Password", isPassword: true),
        SizedBox(height: 20.h),
        const AuthTextField(hintText: "Confirm Password", isPassword: true),
        SizedBox(height: 40.h),

        // Action Button
        _buildResetPasswordButton(context),
      ],
    );
  }

  /// Builds the stylized reset password button
  Widget _buildResetPasswordButton(BuildContext context) {
    return AuthButton(
      text: "Reset Password",
      onPressed: () {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.passwordChangedScreen,
        );
      },
    );
  }
}
