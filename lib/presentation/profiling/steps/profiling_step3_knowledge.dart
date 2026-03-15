import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:ar_chem_lab/core/theme/app_styles.dart';
import 'package:ar_chem_lab/presentation/widget/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Data Model
// ─────────────────────────────────────────────────────────────────────────────

class _KnowledgeOption {
  final IconData icon;
  final String title;
  final String subtitle;
  final String badge;
  final Color accentColor;

  const _KnowledgeOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.accentColor,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 3 Widget — Proficiency
// Asks the user their current chemistry knowledge level.
//
// Selection state is owned by the parent (UserProfilingScreen) and passed
// down via [selectedIndex] + [onSelectionChanged], so the choice is
// preserved when the user navigates back to this step.
// ─────────────────────────────────────────────────────────────────────────────

class ProfilingStep3Knowledge extends StatelessWidget {
  /// The currently selected option index (-1 = nothing selected).
  final int selectedIndex;

  /// Called when the user taps an option.
  final ValueChanged<int> onSelectionChanged;

  /// Called when the user taps Continue (only available after selecting).
  final VoidCallback onNext;

  const ProfilingStep3Knowledge({
    super.key,
    required this.selectedIndex,
    required this.onSelectionChanged,
    required this.onNext,
  });

  // ─── Data ──────────────────────────────────────────────────────────────────

  static const List<_KnowledgeOption> _options = [
    _KnowledgeOption(
      icon: Icons.eco_outlined,
      title: 'Beginner',
      subtitle: 'I am new to chemistry. I know basic concepts like pH and atoms.',
      badge: 'Foundation',
      accentColor: AppColors.lightBlue,
    ),
    _KnowledgeOption(
      icon: Icons.science_outlined,
      title: 'Intermediate',
      subtitle: 'I understand the periodic table, chemical bonding, and reactions.',
      badge: 'Advanced Theory',
      accentColor: Color(0xFF9C7DE7),
    ),
    _KnowledgeOption(
      icon: Icons.biotech_outlined,
      title: 'Advanced',
      subtitle: 'I can balance complex reactions and understand thermodynamics.',
      badge: 'Mastery',
      accentColor: Color(0xFF5AC1B7),
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
        _buildKnowledgeList(),
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
        Text('Knowledge Level', style: AppStyles.bold24whiteOrbitron),
        SizedBox(height: 10.h),
        Text(
          "How much chemistry do you already know? We'll tailor your AR experiments accordingly.",
          style: AppStyles.regular13interLightGray,
        ),
      ],
    );
  }

  Widget _buildKnowledgeList() {
    return Expanded(
      child: ListView.separated(
        itemCount: _options.length,
        separatorBuilder: (_, _) => SizedBox(height: 14.h),
        itemBuilder: (_, i) => _KnowledgeCard(
          option: _options[i],
          isSelected: selectedIndex == i,
          onTap: () => onSelectionChanged(i),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        AppButton(
          text: 'Continue to Placement Test',
          onTap: _hasSelection ? onNext : null,
        ),
        SizedBox(height: 12.h),
        Text(
          'Choosing a level helps us provide relevant starting materials, but you can always change this later.',
          style: AppStyles.regular11interLightGray,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Private Widget — Knowledge Card
// ─────────────────────────────────────────────────────────────────────────────

class _KnowledgeCard extends StatelessWidget {
  final _KnowledgeOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const _KnowledgeCard({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(16.w),
        decoration: _buildDecoration(),
        child: Row(
          children: [
            _buildIcon(),
            SizedBox(width: 14.w),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  // ─── Sub-sections ──────────────────────────────────────────────────────────

  BoxDecoration _buildDecoration() {
    return BoxDecoration(
      color: isSelected ? AppColors.darkBlue : AppColors.darkGray,
      borderRadius: BorderRadius.circular(14.r),
      border: Border.all(
        color: isSelected ? option.accentColor : Colors.transparent,
        width: 1.5,
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 44.w,
      height: 44.w,
      decoration: BoxDecoration(
        color: option.accentColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Icon(option.icon, color: option.accentColor, size: 22.sp),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitleRow(),
        SizedBox(height: 4.h),
        Text(
          option.subtitle,
          style: AppStyles.regular12graySecondary,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildTitleRow() {
    return Row(
      children: [
        Text(
          option.title,
          style: TextStyle(
            fontFamily: 'NirmalaUI',
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
            color: option.accentColor,
          ),
        ),
        SizedBox(width: 8.w),
        _buildBadge(),
      ],
    );
  }

  Widget _buildBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: option.accentColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        option.badge,
        style: TextStyle(
          fontSize: 9.sp,
          color: option.accentColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
