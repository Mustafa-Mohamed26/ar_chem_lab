import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:ar_chem_lab/core/theme/app_styles.dart';
import 'package:ar_chem_lab/core/routes/app_routes.dart';
import 'package:ar_chem_lab/presentation/auth/widgets/auth_text_field.dart';
import 'package:ar_chem_lab/presentation/widget/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        title: Text("Create New Password", style: AppStyles.bold18whiteSecondary),
        centerTitle: false,
      ),
      body: LayoutBuilder(
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
        const AuthTextField(
          label: "New Password",
          prefixIcon: Icons.lock_outline,
          isPassword: true,
        ),
        SizedBox(height: 20.h),
        const AuthTextField(
          label: "Confirm Password",
          prefixIcon: Icons.lock_outline,
          isPassword: true,
        ),
        SizedBox(height: 48.h),
        AppButton(
          text: "Reset Password",
          onTap: () {
            Navigator.pushReplacementNamed(context, AppRoutes.passwordChangedScreen);
          },
        ),
      ],
    );
  }
}
