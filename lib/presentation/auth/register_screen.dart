import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:ar_chem_lab/core/theme/app_styles.dart';
import 'package:ar_chem_lab/core/routes/app_routes.dart';
import 'package:ar_chem_lab/core/utils/dialog_helper.dart';
import 'package:ar_chem_lab/core/utils/validators.dart';
import 'package:ar_chem_lab/presentation/auth/widgets/auth_text_field.dart';
import 'package:ar_chem_lab/presentation/widget/app_button.dart';
import 'package:ar_chem_lab/presentation/auth/cubit/auth_view_model.dart';
import 'package:ar_chem_lab/presentation/auth/cubit/auth_states.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _agreeToTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.white, size: 20.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Create Account", style: AppStyles.bold18whiteSecondary),
        centerTitle: false,
      ),
      body: BlocListener<AuthViewModel, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            DialogHelper.showLoadingDialog(context);
          } else if (state is AuthSuccess) {
            DialogHelper.hideLoadingDialog(context);
            DialogHelper.showSuccessDialog(
              context: context,
              title: "Success",
              desc: state.message,
              onOkPress: () {
                Future.delayed(const Duration(milliseconds: 300), () {
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.emailVerificationScreen,
                    );
                  }
                });
              },
            );
          } else if (state is AuthError) {
            DialogHelper.hideLoadingDialog(context);
            DialogHelper.showErrorDialog(
              context: context,
              title: "Error",
              desc: state.message,
            );
          }
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildHeader(),
                      SizedBox(height: 32.h),
                      _buildFormSection(context),
                      SizedBox(height: 32.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: AppButton(
                          text: "Create Account",
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              if (_agreeToTerms) {
                                context.read<AuthViewModel>().register();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Please agree to terms"),
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 24.h),
                      _buildFooter(context),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          Text("Join the Lab", style: AppStyles.bold29whiteOrbitron),
          SizedBox(height: 12.h),
          Text(
            "Unlock immersive AR experiments and master chemistry through interactive visualization",
            textAlign: TextAlign.center,
            style: AppStyles.regular13interLightGray,
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.gray,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildInputFields(context),
            SizedBox(height: 16.h),
            _buildTermsCheckbox(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputFields(BuildContext context) {
    var viewModel = context.read<AuthViewModel>();
    return Column(
      children: [
        AuthTextField(
          label: "Full Name",
          prefixIcon: Icons.person_outline,
          controller: viewModel.nameController,
          validator: Validators.validateFullName,
        ),
        SizedBox(height: 20.h),
        AuthTextField(
          label: "Email Address",
          prefixIcon: Icons.email_outlined,
          controller: viewModel.emailController,
          validator: Validators.validateEmail,
        ),
        SizedBox(height: 20.h),
        AuthTextField(
          label: "Password",
          prefixIcon: Icons.lock_outline,
          isPassword: true,
          controller: viewModel.passwordController,
          validator: Validators.validatePassword,
        ),
        SizedBox(height: 20.h),
        AuthTextField(
          label: "Confirm Password",
          prefixIcon: Icons.lock_outline,
          isPassword: true,
          controller: viewModel.confirmPasswordController,
          validator: (val) => Validators.validateConfirmPassword(
            val,
            viewModel.passwordController.text,
          ),
        ),
      ],
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      children: [
        SizedBox(
          width: 24.w,
          height: 24.h,
          child: Checkbox(
            value: _agreeToTerms,
            onChanged: (val) => setState(() => _agreeToTerms = val ?? false),
            side: BorderSide(color: AppColors.lightGray),
            activeColor: AppColors.lightBlue,
            checkColor: AppColors.darkBlue,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text.rich(
            TextSpan(
              text: "By creating an account, I agree to the ",
              style: AppStyles.regular10whiteSecondary.copyWith(
                color: AppColors.lightGray,
              ),
              children: [
                TextSpan(
                  text: "Terms of Service",
                  style: TextStyle(color: AppColors.lightBlue),
                ),
                const TextSpan(text: " and "),
                TextSpan(
                  text: "Privacy Policy.",
                  style: TextStyle(color: AppColors.lightBlue),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account? ",
          style: AppStyles.regular16WiteSecondary.copyWith(
            fontSize: 14.sp,
            color: AppColors.lightGray,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
          },
          child: Text(
            "Sign In",
            style: AppStyles.bold16whiteSecondary.copyWith(
              fontSize: 14.sp,
              color: AppColors.lightBlue,
            ),
          ),
        ),
      ],
    );
  }
}
