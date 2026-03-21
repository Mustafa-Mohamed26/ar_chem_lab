import 'package:ar_chem_lab/core/theme/app_styles.dart';
import 'package:ar_chem_lab/presentation/profiling/widgets/profiling_select_card.dart';
import 'package:ar_chem_lab/presentation/widget/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Data Model
// ─────────────────────────────────────────────────────────────────────────────

class _GoalOption {
  final IconData icon;
  final String title;
  final String subtitle;

  const _GoalOption({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 1 Widget — Personalize
// Asks the user why they want to learn chemistry.
//
// Selection state is owned by the parent (UserProfilingScreen) and passed
// down via [selectedIndex] + [onSelectionChanged], so the choice is
// preserved when the user navigates back to this step.
// ─────────────────────────────────────────────────────────────────────────────

class ProfilingStep1Goal extends StatelessWidget {
  /// The currently selected option index (-1 = nothing selected).
  final int selectedIndex;

  /// Called when the user taps an option.
  final ValueChanged<int> onSelectionChanged;

  /// Called when the user taps Continue (only available after selecting).
  final VoidCallback onNext;

  const ProfilingStep1Goal({
    super.key,
    required this.selectedIndex,
    required this.onSelectionChanged,
    required this.onNext,
  });

  // ─── Data ──────────────────────────────────────────────────────────────────

  static const List<_GoalOption> _options = [
    _GoalOption(
      icon: Icons.school_outlined,
      title: 'School Learning',
      subtitle: 'Align with your current academic curriculum',
    ),
    _GoalOption(
      icon: Icons.menu_book_outlined,
      title: 'Improve Knowledge',
      subtitle: 'Master advanced topics and theories',
    ),
    _GoalOption(
      icon: Icons.science_outlined,
      title: 'Curiosity',
      subtitle: 'Understand how molecules are made',
    ),
    _GoalOption(
      icon: Icons.assignment_outlined,
      title: 'Exam Preparation',
      subtitle: 'Targeted practice for chemistry certificates',
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
        _buildOptionsList(),
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
        Text(
          'Why do you want to\nlearn chemistry?',
          style: AppStyles.bold24whiteOrbitron,
        ),
        SizedBox(height: 10.h),
        Text(
          "We'll customize your experiments and study path based on your goals.",
          style: AppStyles.regular13interLightGray,
        ),
      ],
    );
  }

  Widget _buildOptionsList() {
    return Expanded(
      child: ListView.separated(
        itemCount: _options.length,
        separatorBuilder: (_, _) => SizedBox(height: 12.h),
        itemBuilder: (_, i) => ProfilingSelectCard(
          icon: _options[i].icon,
          title: _options[i].title,
          subtitle: _options[i].subtitle,
          isSelected: selectedIndex == i,
          onTap: () => onSelectionChanged(i),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        AppButton(text: 'Continue', onTap: _hasSelection ? onNext : null),
        SizedBox(height: 12.h),
        Text(
          'You can always update your learning objectives in your profile settings later.',
          style: AppStyles.regular11interLightGray,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}
