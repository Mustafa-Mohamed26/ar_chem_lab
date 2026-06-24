import 'package:ar_chem_lab/core/routes/app_routes.dart';
import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:ar_chem_lab/core/theme/app_styles.dart';
import 'package:ar_chem_lab/presentation/widget/circular_gradients_painter.dart';
import 'package:ar_chem_lab/presentation/widget/notch_painter.dart';
import 'package:ar_chem_lab/core/services/ar_unity_service.dart';
import 'package:ar_chem_lab/core/utils/dialog_helper.dart';
import 'package:ar_chem_lab/presentation/auth/cubit/auth_view_model.dart';
import 'package:ar_chem_lab/presentation/auth/cubit/auth_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GradientBottomNavBar extends StatelessWidget {
  const GradientBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110.h, // Increased height to accommodate the elevated button
      color: AppColors.transparent,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // --- PART 1: The Nav Bar with Notch and Gradient Border ---
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width.w, 80.h),
            painter: NotchPainter(), // Drawing the notched border
            child: Container(
              height: 85.h,
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  navItem(
                    icon: Icons.history,
                    label: "History",
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.historyScreen);
                    },
                  ),
                  navItem(
                    icon: Icons.auto_awesome,
                    label: "Chatbot",
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.chatBotScreen);
                    },
                  ),
                ],
              ),
            ),
          ),

          // --- PART 2: The Floating Action Button with Gradient Border ---
          Positioned(
            top: 1, // Lifts the button out of the bar
            child: GestureDetector(
              onTap: () async {
                final authState = context.read<AuthViewModel>().state;
                bool isExpert = false;
                if (authState is ProfileSuccess) {
                  isExpert = authState.user.level.toLowerCase() == 'expert';
                }
                
                if (isExpert) {
                  await ARUnityService.launchUnity("ExpertScene");
                } else {
                  DialogHelper.showErrorDialog(
                    context: context,
                    title: "Access Denied",
                    desc: "You must be expert level to enter the My Lab.",
                  );
                }
              },
              child: CustomPaint(
                painter: CircleGradientPainter(), // Drawing the button's border
                child: Container(
                  width: 60.w,
                  height: 60.h,
                  margin: const EdgeInsets.all(
                    2,
                  ), // Padding between border and icon
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.darkGray, // Match the bar background
                  ),
                  child: const Icon(
                    Icons.science,
                    color: AppColors.white,
                    size: 32,
                  ),
                ),
              ),
            ),
          ),

          // Labels for the center button (optional)
          Positioned(
            bottom: 10,
            child: Text("My Lab", style: AppStyles.bold14whiteInter),
          ),
        ],
      ),
    );
  }

  Widget navItem({
    required IconData icon,
    required String label,
    VoidCallback? onTap, // This is a function reference
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque, // Ensures the entire area is clickable
      onTap: onTap, // PASS the function directly here
      child: SizedBox(
        width: 90.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.white, size: 40.sp),
            Text(label, style: AppStyles.medium12InterWhite),
          ],
        ),
      ),
    );
  }
}
