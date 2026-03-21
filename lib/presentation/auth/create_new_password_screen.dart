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

class CreateNewPasswordScreen extends StatelessWidget {
  const CreateNewPasswordScreen({super.key});

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
        title: Text(
          "Create New Password",
          style: AppStyles.bold18whiteSecondary,
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
              title: "Success",
              desc: state.message,
              onOkPress: () {
                Future.delayed(const Duration(milliseconds: 300), () {
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.passwordChangedScreen,
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
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 34.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildHeader(),
                        SizedBox(height: 48.h),
                        _buildForm(context),
                        SizedBox(height: 48.h),
                      ],
                    ),
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
        Text(
          "Create new password",
          style: AppStyles.bold24whiteOrbitron,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16.h),
        Text(
          "Your new password must be unique from those previously used.",
          style: AppStyles.regular13interLightGray,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildForm(BuildContext context) {
    return Column(
      children: [
        AuthTextField(
          label: "New Password",
          prefixIcon: Icons.lock_outline,
          isPassword: true,
          controller: context.read<AuthViewModel>().passwordController,
        ),
        SizedBox(height: 20.h),
        AuthTextField(
          label: "Confirm Password",
          prefixIcon: Icons.lock_outline,
          isPassword: true,
          controller: context.read<AuthViewModel>().confirmPasswordController,
        ),
        SizedBox(height: 48.h),
        AppButton(
          text: "Reset Password",
          onTap: () {
            context.read<AuthViewModel>().resetPassword();
          },
        ),
      ],
    );
  }
}
