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

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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

  /// Builds the top logo and title of the register screen
  Widget _buildHeader() {
    return Column(
      children: [
        Image.asset(AppAssets.appLogo, width: 100.w, height: 100.h),
        SizedBox(height: 10.h),
        Text("SIGN UP", style: AppStyles.bold32whitePrimary),
      ],
    );
  }

  /// Builds the main form container with the gradient border
  Widget _buildFormContainer(BuildContext context) {
    return AuthFormContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // --- HEADER SECTION ---
          _buildHeader(),
          SizedBox(height: 20.h),
          // Input Fields
          _buildInputFields(),
          SizedBox(height: 40.h),

          // Action Buttons
          _buildSignUpButton(context),
          SizedBox(height: 30.h),
          _buildFooter(context),
        ],
      ),
    );
  }

  /// Builds the Sign Up text fields
  Widget _buildInputFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AuthTextField(hintText: "Enter your name", isPassword: false),
        SizedBox(height: 20.h),
        const AuthTextField(hintText: "Enter your email", isPassword: false),
        SizedBox(height: 20.h),
        const AuthTextField(hintText: "Enter your password", isPassword: true),
        SizedBox(height: 20.h),
        const AuthTextField(hintText: "Confirm Password", isPassword: true),
      ],
    );
  }

  /// Builds the stylized sign up button
  Widget _buildSignUpButton(BuildContext context) {
    return AuthButton(
      text: "Sign Up",
      onPressed: () {
        Navigator.pushReplacementNamed(context, AppRoutes.homeScreen);
      },
    );
  }

  /// Builds the 'SignIn' footer text
  Widget _buildFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account? ",
          style: AppStyles.regular12whiteSecondary,
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
          },
          child: Text(
            "SignIn",
            style: AppStyles.bold12whiteSecondary.copyWith(
              color: AppColors.lavender,
            ),
          ),
        ),
      ],
    );
  }
}
