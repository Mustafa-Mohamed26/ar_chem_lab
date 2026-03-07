import 'package:ar_chem_lab/core/constants/app_assets.dart';
import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:ar_chem_lab/core/theme/app_gradients.dart';
import 'package:ar_chem_lab/core/theme/app_styles.dart';
import 'package:ar_chem_lab/core/routes/app_routes.dart';
import 'package:ar_chem_lab/presentation/auth/widgets/auth_text_field.dart';
import 'package:ar_chem_lab/presentation/auth/widgets/auth_button.dart';
import 'package:ar_chem_lab/presentation/auth/widgets/auth_form_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
          child: Column(
            children: [
              // --- HEADER SECTION ---
              SizedBox(height: 40.h),
              _buildHeader(),
              SizedBox(height: 40.h),

              // --- FORM SECTION ---
              Expanded(child: _buildFormContainer(context)),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET EXTRACTS ---

  /// Builds the top logo and title of the login screen
  Widget _buildHeader() {
    return Column(
      children: [
        Image.asset(AppAssets.appLogo, width: 140.w, height: 140.h),
        SizedBox(height: 10.h),
        Text("HELLO, ALCHEMIST!", style: AppStyles.bold32whitePrimary),
      ],
    );
  }

  /// Builds the main form container with the gradient border
  Widget _buildFormContainer(BuildContext context) {
    return AuthFormContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Title
          Text(
            "LOGIN",
            style: AppStyles.bold32whitePrimary.copyWith(letterSpacing: 2),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 35.h),

          // Input Fields
          _buildInputFields(context),
          SizedBox(height: 40.h),

          // Action Buttons
          _buildLoginButton(context),
          SizedBox(height: 30.h),
          _buildFooter(context),
        ],
      ),
    );
  }

  /// Builds the Email and Password text fields
  Widget _buildInputFields(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AuthTextField(hintText: "Enter your email", isPassword: false),
        SizedBox(height: 20.h),
        const AuthTextField(hintText: "Enter your password", isPassword: true),
        SizedBox(height: 8.h),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.forgotPasswordScreen);
            },
            child: Text(
              "Forgot Password?",
              style: AppStyles.regular12whiteSecondary.copyWith(
                color: AppColors.lavender,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the stylized login button
  Widget _buildLoginButton(BuildContext context) {
    return AuthButton(
      text: "Login",
      onPressed: () {
        Navigator.pushReplacementNamed(context, AppRoutes.homeScreen);
      },
    );
  }

  /// Builds the 'Register Now' footer text
  Widget _buildFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: AppStyles.regular12whiteSecondary,
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, AppRoutes.registerScreen);
          },
          child: Text(
            "Register Now",
            style: AppStyles.bold12whiteSecondary.copyWith(
              color: AppColors.lavender,
            ),
          ),
        ),
      ],
    );
  }
}
