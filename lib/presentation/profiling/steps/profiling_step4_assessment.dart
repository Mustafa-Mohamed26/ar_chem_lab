import 'package:ar_chem_lab/core/routes/app_routes.dart';
import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:ar_chem_lab/core/theme/app_styles.dart';
import 'package:ar_chem_lab/presentation/widget/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Data Model
// ─────────────────────────────────────────────────────────────────────────────

class _TestItem {
  final IconData icon;
  final String title;
  final String subtitle;

  const _TestItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 4 Widget — Level Assess
// Shows the placement test summary. Lets user start the test or skip.
// ─────────────────────────────────────────────────────────────────────────────

class ProfilingStep4Assessment extends StatelessWidget {
  const ProfilingStep4Assessment({super.key});

  // ─── Data ──────────────────────────────────────────────────────────────────

  static const List<_TestItem> _testItems = [
    _TestItem(
      icon: Icons.quiz_outlined,
      title: '15 Questions',
      subtitle: 'Focusing on periodic trends, bonding, and stoichiometry.',
    ),
    _TestItem(
      icon: Icons.timer_outlined,
      title: '25 Minutes',
      subtitle: 'Estimated time based on your current grade level.',
    ),
    _TestItem(
      icon: Icons.analytics_outlined,
      title: 'Adaptive Results',
      subtitle: 'Lab difficulty automatically adjusts to your performance.',
    ),
  ];

  /// Starts the proficiency placement test.
  void _startTest(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.profilingTestScreen);
  }

  /// Skips the test and goes straight to the home screen.
  void _skipTest(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.homeScreen,
      (route) => false,
    );
  }

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: _buildScrollableContent()),
        _buildActions(context),
      ],
    );
  }

  // ─── Sections ──────────────────────────────────────────────────────────────

  Widget _buildScrollableContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHero(),
          SizedBox(height: 28.h),
          _buildTestStructureBox(),
          SizedBox(height: 12.h),
          _buildVerifiedBadge(),
        ],
      ),
    );
  }

  Widget _buildHero() {
    return Column(
      children: [
        _buildLabIcon(),
        SizedBox(height: 6.h),
        const _ArReadyBadge(),
        SizedBox(height: 16.h),
        Text(
          'Find Your Starting Point',
          style: AppStyles.bold24whiteOrbitron,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 12.h),
        Text(
          "Let's determine your chemistry proficiency to customize your interactive experiments.",
          style: AppStyles.regular13interLightGray,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLabIcon() {
    return Container(
      width: 60.w,
      height: 60.w,
      decoration: BoxDecoration(
        color: AppColors.darkGray,
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Icon(
        Icons.science_outlined,
        color: AppColors.lightBlue,
        size: 42.sp,
      ),
    );
  }

  Widget _buildTestStructureBox() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.darkGray,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.secondaryDarkGray),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TEST STRUCTURE',
            style: TextStyle(
              fontFamily: 'NirmalaUI',
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.lightBlue,
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: 16.h),
          ..._testItems.map((item) => _buildTestItemRow(item)),
        ],
      ),
    );
  }

  Widget _buildTestItemRow(_TestItem item) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(item.icon, color: AppColors.lightGray, size: 20.sp),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: AppStyles.bold14whiteSecondary),
                  SizedBox(height: 2.h),
                  Text(item.subtitle, style: AppStyles.regular12graySecondary),
                ],
              ),
            ),
          ],
        ),
        if (item != _testItems.last) SizedBox(height: 14.h),
      ],
    );
  }

  Widget _buildVerifiedBadge() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.verified_outlined, color: AppColors.lightBlue, size: 12.sp),
        SizedBox(width: 4.w),
        Text(
          'VERIFIED CURRICULUM-ALIGNED ASSESSMENT',
          style: TextStyle(
            color: AppColors.lightBlue,
            fontSize: 9.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20.h),
        AppButton(
          text: 'Start Test  ›',
          onTap: () => _startTest(context),
        ),
        SizedBox(height: 12.h),
        GestureDetector(
          onTap: () => _skipTest(context),
          child: Text(
            'Skip and explore later',
            style: AppStyles.semiBold14lightBlueInter.copyWith(fontSize: 13.sp),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'You can retake the placement test from your profile settings at any time.',
          style: AppStyles.regular11interLightGray,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Private Widget — AR Ready Badge
// ─────────────────────────────────────────────────────────────────────────────

class _ArReadyBadge extends StatelessWidget {
  const _ArReadyBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.lightBlue.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.lightBlue.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, color: AppColors.lightBlue, size: 12.sp),
          SizedBox(width: 4.w),
          Text(
            'AR Ready',
            style: TextStyle(
              color: AppColors.lightBlue,
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
