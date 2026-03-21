import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:ar_chem_lab/core/theme/app_styles.dart';
import 'package:ar_chem_lab/core/routes/app_routes.dart';
import 'package:ar_chem_lab/presentation/auth/widgets/auth_text_field.dart';
import 'package:ar_chem_lab/presentation/widget/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ar_chem_lab/presentation/auth/cubit/auth_view_model.dart';
import 'package:ar_chem_lab/presentation/auth/cubit/auth_states.dart';
import 'package:ar_chem_lab/core/utils/dialog_helper.dart';
import 'package:ar_chem_lab/core/utils/validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _rememberMe = false;

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
              title: "Login Successful",
              desc: state.message,
              onOkPress: () {
                Future.delayed(const Duration(milliseconds: 300), () {
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.homeScreen,
                    );
                  }
                });
              },
            );
          } else if (state is AuthError) {
            DialogHelper.hideLoadingDialog(context);
            DialogHelper.showErrorDialog(
              context: context,
              title: "Login Failed",
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
          Text("Welcome Back", style: AppStyles.bold29whiteOrbitron),
          SizedBox(height: 12.h),
          Text(
            "Sign in to continue your experiments",
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
            _buildOptionsRow(),
            SizedBox(height: 24.h),
            AppButton(
              text: "Sign In",
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  context.read<AuthViewModel>().login(rememberMe: _rememberMe);
                }
              },
            ),
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
      ],
    );
  }

  Widget _buildOptionsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: 24.w,
              height: 24.h,
              child: Checkbox(
                value: _rememberMe,
                onChanged: (val) => setState(() => _rememberMe = val ?? false),
                side: BorderSide(color: AppColors.lightGray),
                activeColor: AppColors.lightBlue,
                checkColor: AppColors.darkBlue,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              "Remember me",
              style: AppStyles.regular12whiteSecondary.copyWith(
                color: AppColors.lightGray,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.forgotPasswordScreen);
          },
          child: Text(
            "Forgot Password?",
            style: AppStyles.semiBold14lightBlueInter.copyWith(fontSize: 12.sp),
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
          "Don't have an account? ",
          style: AppStyles.regular16WiteSecondary.copyWith(
            fontSize: 14.sp,
            color: AppColors.lightGray,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, AppRoutes.registerScreen);
          },
          child: Text(
            "Sign Up",
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
