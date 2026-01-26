import 'package:ar_chem_lab/presentation/widget/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ar_chem_lab/core/constants/app_assets.dart';
import 'package:ar_chem_lab/core/constants/app_colors.dart';
import 'package:ar_chem_lab/core/constants/app_styles.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentIndex = 0; // Tracks the current onboarding page

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

  // ------------------- Build method -------------------
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: const BoxDecoration(
        // Background gradient for the whole screen
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.midnightBlue, AppColors.royalBlue],
          stops: [0.47, 1.0],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildImageSection(),
                  _buildTitle(),
                  _buildSubtitle(),
                  SizedBox(height: 20.h),
                  _buildDotsIndicator(),
                  SizedBox(height: 20.h),
                  _buildButton(),
                  SizedBox(height: 20.h),
                ],
              ),

              // Back button
              if (currentIndex > 0) _buildBackButton(),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------- Sections -------------------

  /// Top image section
  Widget _buildImageSection() {
    return Expanded(
      child: Center(
        child: Image.asset(images[currentIndex]),
      ),
    );
  }

  /// Title text
  Widget _buildTitle() {
    return Text(
      titles[currentIndex],
      style: AppStyles.bold32white,
      textAlign: TextAlign.center,
    );
  }

  /// Subtitle text
  Widget _buildSubtitle() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Text(
        subtitles[currentIndex],
        style: AppStyles.regular18white,
        textAlign: TextAlign.center,
      ),
    );
  }

  /// Animated dots indicator
  Widget _buildDotsIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(images.length, (index) {
        bool isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          height: 10.h,
          width: isActive ? 24.w : 10.w,
          decoration: BoxDecoration(
            color: isActive ? AppColors.white : AppColors.lowSaturationGray,
            borderRadius: BorderRadius.circular(12),
          ),
        );
      }),
    );
  }

  /// Gradient button
  Widget _buildButton() {
    return GradientButton(
      text: buttonTexts[currentIndex],
      onTap: () {
        if (currentIndex < images.length - 1) {
          setState(() {
            currentIndex++;
          });
        } else {
          print("Finished onboarding!");
          // Navigate to main app
        }
      },
    );
  }

  /// Back button positioned at top left
  Widget _buildBackButton() {
    return Positioned(
      top: 16.h,
      left: 16.w,
      child: GestureDetector(
        onTap: () {
          setState(() {
            currentIndex--;
          });
        },
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
              Text("Back", style: AppStyles.bold18white),
            ],
          ),
        ),
      ),
    );
  }
}


