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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ar_chem_lab/presentation/auth/cubit/auth_view_model.dart';
import 'package:ar_chem_lab/presentation/auth/cubit/auth_states.dart';
import 'package:ar_chem_lab/config/di/di.dart';
import 'package:ar_chem_lab/core/utils/dialog_helper.dart';
import 'package:ar_chem_lab/core/utils/validators.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  // --- MAIN BUILD METHOD ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => getIt<AuthViewModel>(),
        child: BlocConsumer<AuthViewModel, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              DialogHelper.showSuccessDialog(
                context: context,
                title: "Success",
                desc: state.message,
                onOkPress: () {
                  Future.delayed(const Duration(milliseconds: 300), () {
                    if (context.mounted) {
                      Navigator.pushReplacementNamed(
                          context, AppRoutes.homeScreen);
                    }
                  });
                },
              );
            } else if (state is AuthError) {
              DialogHelper.showErrorDialog(
                context: context,
                title: "Error",
                desc: state.message,
              );
            }
          },
          builder: (context, state) {
            return Container(
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
                    Expanded(child: _buildFormContainer(context, state)),
                  ],
                ),
              ),
            );
          },
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
  Widget _buildFormContainer(BuildContext context, AuthState state) {
    return AuthFormContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // --- HEADER SECTION ---
          _buildHeader(),
          SizedBox(height: 20.h),
          // Input Fields
          Form(
            key: context.read<AuthViewModel>().formKey,
            child: _buildInputFields(context),
          ),
          SizedBox(height: 40.h),

          // Action Buttons
          _buildSignUpButton(context, state),
          SizedBox(height: 30.h),
          _buildFooter(context),
        ],
      ),
    );
  }

  /// Builds the Sign Up text fields
  Widget _buildInputFields(BuildContext context) {
    var viewModel = context.read<AuthViewModel>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthTextField(
            controller: viewModel.nameController,
            hintText: "Enter your name",
            validator: Validators.validateFullName,
            isPassword: false),
        SizedBox(height: 20.h),
        AuthTextField(
            controller: viewModel.emailController,
            hintText: "Enter your email",
            validator: Validators.validateEmail,
            isPassword: false),
        SizedBox(height: 20.h),
        AuthTextField(
            controller: viewModel.passwordController,
            hintText: "Enter your password",
            validator: Validators.validatePassword,
            isPassword: true),
        SizedBox(height: 20.h),
        AuthTextField(
            controller: viewModel.confirmPasswordController,
            hintText: "Confirm Password",
            validator: (val) => Validators.validateConfirmPassword(
                  val,
                  viewModel.passwordController.text,
                ),
            isPassword: true),
      ],
    );
  }

  /// Builds the stylized sign up button
  Widget _buildSignUpButton(BuildContext context, AuthState state) {
    return AuthButton(
      text: "Sign Up",
      isLoading: state is AuthLoading,
      onPressed: () {
        context.read<AuthViewModel>().register();
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
