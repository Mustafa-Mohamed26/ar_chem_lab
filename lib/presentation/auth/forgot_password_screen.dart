import 'package:ar_chem_lab/core/constants/app_assets.dart';
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

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

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
        title: Text("Reset Password", style: AppStyles.bold18whiteSecondary),
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
                    Navigator.pushNamed(
                      context,
                      AppRoutes.otpVerificationScreen,
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
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 38.w),
                        child: _buildHeader(),
                      ),
                      SizedBox(height: 48.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 38.w),
                        child: _buildForm(context),
                      ),
                      SizedBox(height: 104.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: _buildSpamNote(),
                      ),
                      SizedBox(height: 16.h),
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
    return Column(
      children: [
        Image.asset(AppAssets.forgotPasswordImage, height: 120.h),
        SizedBox(height: 12.h),
        Text(
          "Forgot Password?",
          style: AppStyles.bold24whiteOrbitron,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16.h),
        Text(
          "Don't worry! Enter your email below and we'll send you a link to reset your password.\nThe OTP will be sent to your email.",
          style: AppStyles.regular13interLightGray,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AuthTextField(
          label: "Email Address",
          prefixIcon: Icons.email_outlined,
          controller: context.read<AuthViewModel>().emailController,
        ),
        SizedBox(height: 8.h),
        Text(
          "# Must be the email associated with your lab account.",
          style: AppStyles.regular11interLightGray,
        ),
        SizedBox(height: 32.h),
        AppButton(
          text: "Send Reset Link",
          onTap: () {
            context.read<AuthViewModel>().forgotPassword();
          },
        ),
      ],
    );
  }

  Widget _buildSpamNote() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E26),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text.rich(
        TextSpan(
          text: "Haven't received the email? Check your spam folder or ",
          style: AppStyles.regular10whiteSecondary.copyWith(
            color: AppColors.lightGray,
          ),
          children: [
            TextSpan(
              text: "try again.",
              style: TextStyle(color: AppColors.lightBlue),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.arrow_back, color: AppColors.lightGray, size: 16.sp),
          SizedBox(width: 8.w),
          Text("Back to Sign In", style: AppStyles.semiBold11lightGrayInter),
        ],
      ),
    );
  }
}
