import 'package:ar_chem_lab/core/theme/app_styles.dart';
import 'package:ar_chem_lab/presentation/profiling/widgets/profiling_grid_card.dart';
import 'package:ar_chem_lab/presentation/widget/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Data Model
// ─────────────────────────────────────────────────────────────────────────────

class _EducationOption {
  final IconData icon;
  final String title;
  final String subtitle;

  const _EducationOption({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 2 Widget — Education
// Asks the user their current education level.
//
// Selection state is owned by the parent (UserProfilingScreen) and passed
// down via [selectedIndex] + [onSelectionChanged], so the choice is
// preserved when the user navigates back to this step.
// ─────────────────────────────────────────────────────────────────────────────

class ProfilingStep2Education extends StatelessWidget {
  /// The currently selected option index (-1 = nothing selected).
  final int selectedIndex;

  /// Called when the user taps an option.
  final ValueChanged<int> onSelectionChanged;

  /// Called when the user taps Continue (only available after selecting).
  final VoidCallback onNext;

  const ProfilingStep2Education({
    super.key,
    required this.selectedIndex,
    required this.onSelectionChanged,
    required this.onNext,
  });

  // ─── Data ──────────────────────────────────────────────────────────────────

  static const List<_EducationOption> _options = [
    _EducationOption(
      icon: Icons.home_outlined,
      title: "Middle School",
      subtitle: "Grades 6–8",
    ),
    _EducationOption(
      icon: Icons.menu_book_outlined,
      title: "High School",
      subtitle: "Grades 9–12",
    ),
    _EducationOption(
      icon: Icons.school_outlined,
      title: "University",
      subtitle: "Degree & Research",
    ),
    _EducationOption(
      icon: Icons.self_improvement_outlined,
      title: "Self-Learner",
      subtitle: "Curious Minds",
    ),
  ];

  // ─── Helpers ───────────────────────────────────────────────────────────────

  bool get _hasSelection => selectedIndex >= 0;

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        SizedBox(height: 28.h),
        _buildGrid(),
        SizedBox(height: 20.h),
        _buildFooter(),
      ],
    );
  }

  // ─── Sections ──────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("What's your level?", style: AppStyles.bold24whiteOrbitron),
        SizedBox(height: 10.h),
        Text(
          'We personalize your AR lab experiments based on your current academic path.',
          style: AppStyles.regular13interLightGray,
        ),
      ],
    );
  }

  Widget _buildGrid() {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 14.w,
        mainAxisSpacing: 14.h,
        childAspectRatio: 1.1,
        children: List.generate(
          _options.length,
          (i) => ProfilingGridCard(
            icon: _options[i].icon,
            title: _options[i].title,
            subtitle: _options[i].subtitle,
            isSelected: selectedIndex == i,
            onTap: () => onSelectionChanged(i),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        AppButton(
          text: 'Continue',
          onTap: _hasSelection ? onNext : null,
        ),
        SizedBox(height: 12.h),
        Text(
          'SELECT A LEVEL TO PROCEED WITH YOUR PERSONALIZED JOURNEY',
          style: AppStyles.regular11interLightGray.copyWith(letterSpacing: 0.5),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}
