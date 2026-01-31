import 'package:ar_chem_lab/core/routes/app_routes.dart';
import 'package:ar_chem_lab/core/theme/app_gradients.dart';
import 'package:ar_chem_lab/core/theme/app_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ar_chem_lab/core/constants/app_assets.dart';
import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:ar_chem_lab/core/theme/app_styles.dart';
import 'package:ar_chem_lab/presentation/widget/gradient_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentIndex = 0;

  // ------------------- Onboarding data -------------------
  final List<String> images = [
    AppAssets.onboarding1Image,
    AppAssets.onboarding2Image,
    AppAssets.onboarding3Image,
  ];

  final List<String> titles = [
    'Welcome to AR ChemLab.',
    'Explore chemistry in a whole new way',
    'Safe and interactive Experiments',
  ];

  final List<String> subtitles = [
    "Discover science in a new dimension through interactive augmented reality",
    "Bring molecules and reactions to life with Augmented Reality.",
    "Mix chemicals safely and watch reactions instantly",
  ];

  final List<String> buttonTexts = ["Let’s start", "Next", "Get Started"];

  // ------------------- Opacity animation control -------------------
  double _opacity = 1.0;

  void _nextPage() async {
    // Fade out
    setState(() {
      _opacity = 0.0;
    });

    await Future.delayed(const Duration(milliseconds: 300));

    // Change content
    setState(() {
      if (currentIndex < images.length - 1) {
        currentIndex++;
      } else {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.homeScreen,
          (_) => false,
        );
        // Navigate to main app
      }
      _opacity = 1.0; // Fade in
    });
  }

  void _previousPage() async {
    setState(() {
      _opacity = 0.0;
    });

    await Future.delayed(const Duration(milliseconds: 300));

    setState(() {
      if (currentIndex > 0) {
        currentIndex--;
      }
      _opacity = 1.0;
    });
  }

  // ------------------- Build method -------------------
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPadding.screen,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppAssets.onboardingBackground),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildImageSection(),
                  _buildTitle(),
                  SizedBox(height: 20.h),
                  _buildSubtitle(),
                  SizedBox(height: 20.h),
                  _buildDotsIndicator(),
                  SizedBox(height: 40.h),
                  _buildButton(),
                  SizedBox(height: 40.h),
                ],
              ),
              if (currentIndex > 0) _buildBackButton(),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------- Sections -------------------

  // Image section with fade animation
  Widget _buildImageSection() {
    return Expanded(
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: _opacity,
        child: Image.asset(
          images[currentIndex],
          key: ValueKey<int>(currentIndex),
        ),
      ),
    );
  }

  // Title
  Widget _buildTitle() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: _opacity,
      child: Text(
        titles[currentIndex],
        key: ValueKey<int>(currentIndex),
        style: AppStyles.bold32whitePrimary,
        textAlign: TextAlign.center,
      ),
    );
  }

  // Subtitle
  Widget _buildSubtitle() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: _opacity,
      child: Padding(
        key: ValueKey<int>(currentIndex),
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Text(
          subtitles[currentIndex],
          style: AppStyles.regular18whiteSecondary,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // Dots indicator
  Widget _buildDotsIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(images.length, (index) {
        bool isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut, // Smooth animation
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          height: 10.h,
          width: isActive ? 24.w : 10.w, // Stretch active dot
          decoration: BoxDecoration(
            color: isActive ? AppColors.white : AppColors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        );
      }),
    );
  }

  /// Gradient button
  Widget _buildButton() {
    return GradientButton(text: buttonTexts[currentIndex], onTap: _nextPage);
  }

  /// Back button
  Widget _buildBackButton() {
    return Positioned(
      top: 16.h,
      left: 16.w,
      child: GestureDetector(
        onTap: _previousPage,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: AppColors.lowSaturationGray,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.arrow_back, color: Colors.white, size: 20.sp),
              SizedBox(width: 8.w),
              Text("Back", style: AppStyles.bold18whiteSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
