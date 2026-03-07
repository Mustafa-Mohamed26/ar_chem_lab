import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:ar_chem_lab/core/theme/app_gradients.dart';
import 'package:ar_chem_lab/core/theme/app_styles.dart';
import 'package:ar_chem_lab/core/routes/app_routes.dart';
import 'package:ar_chem_lab/presentation/auth/widgets/auth_text_field.dart';
import 'package:ar_chem_lab/presentation/auth/widgets/auth_button.dart';
import 'package:ar_chem_lab/presentation/widget/gradient_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

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
                SizedBox(height: 20.h),

                // --- FOOTER SECTION ---
                _buildFooter(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- WIDGET EXTRACTS ---

  /// Builds the top title and subtitle of the forgot password screen
  Widget _buildHeader() {
    return Column(
      children: [
        Text("Forgot Password?", style: AppStyles.bold32whitePrimary),
        SizedBox(height: 16.h),
        Text(
          "Don't worry! It occurs. Please enter the email address linked with your account.",
          style: AppStyles.regular12whiteSecondary.copyWith(fontSize: 14.sp),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Builds the form with the email field and the send code button
  Widget _buildForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Input Field
        const AuthTextField(hintText: "Enter your email", isPassword: false),
        SizedBox(height: 30.h),

        // Action Button
        _buildSendCodeButton(context),
      ],
    );
  }

  /// Builds the stylized send code button
  Widget _buildSendCodeButton(BuildContext context) {
    return AuthButton(
      text: "Verify",
      onPressed: () {
        Navigator.pushNamed(context, AppRoutes.createNewPasswordScreen);
      },
    );
  }

  /// Builds the 'Login' footer text
  Widget _buildFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Remember Password? ", style: AppStyles.regular12whiteSecondary),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
          },
          child: Text(
            "Login",
            style: AppStyles.bold12whiteSecondary.copyWith(
              color: AppColors.lavender,
            ),
          ),
        ),
      ],
    );
  }
}
