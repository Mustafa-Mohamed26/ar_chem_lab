import 'package:ar_chem_lab/core/routes/app_routes.dart';
import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:ar_chem_lab/core/theme/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Result Model
//
// Derives level, description, and unlocked topics from the test score.
// ─────────────────────────────────────────────────────────────────────────────

class _LevelResult {
  final String label;          // e.g. "BEGINNER"
  final String description;   // shown below the level label
  final Color accentColor;    // icon + badge tint
  final IconData icon;
  final List<String> topics;  // unlocked topics list

  const _LevelResult({
    required this.label,
    required this.description,
    required this.accentColor,
    required this.icon,
    required this.topics,
  });
}

_LevelResult _resolveLevel(double accuracy) {
  if (accuracy >= 0.71) {
    return const _LevelResult(
      label: 'ADVANCED',
      description: "Outstanding! You have mastery-level understanding of chemistry. You're ready for our most complex AR synthesis experiments.",
      accentColor: Color(0xFF5AC1B7),
      icon: Icons.military_tech_outlined,
      topics: ['Organic Synthesis', 'Thermodynamics', 'Electrochemistry', 'Quantum Chemistry'],
    );
  } else if (accuracy >= 0.41) {
    return const _LevelResult(
      label: 'INTERMEDIATE',
      description: "Impressive! You have a solid grasp of atomic structures and stoichiometry. You're ready for complex AR synthesis experiments.",
      accentColor: Color(0xFF9C7DE7),
      icon: Icons.emoji_events_outlined,
      topics: ['Organic Chem', 'Gas Laws', 'Redox Reactions', 'Lab Safety AR'],
    );
  } else {
    return const _LevelResult(
      label: 'BEGINNER',
      description: "Great start! We'll guide you through the fundamentals of chemistry step by step with interactive AR experiments.",
      accentColor: AppColors.lightBlue,
      icon: Icons.science_outlined,
      topics: ['Atomic Structure', 'Periodic Table', 'Simple Bonding', 'Lab Basics AR'],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ProfilingResultScreen
//
// Displays the user's placement test results including:
//   • Their determined proficiency level (Beginner / Intermediate / Advanced)
//   • Accuracy percentage
//   • Time taken (pace)
//   • Topics unlocked based on their level
//
// Receives arguments from ProfilingTestScreen via route settings:
//   { 'correctAnswers': int, 'totalQuestions': int, 'duration': Duration }
// ─────────────────────────────────────────────────────────────────────────────

class ProfilingResultScreen extends StatelessWidget {
  const ProfilingResultScreen({super.key});

  // ─── Navigation ────────────────────────────────────────────────────────────

  void _startLearning(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.homeScreen,
      (route) => false,
    );
  }

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    // Read arguments passed from ProfilingTestScreen.
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final int correct = args['correctAnswers'] as int;
    final int total = args['totalQuestions'] as int;
    final Duration elapsed = args['duration'] as Duration;

    final double accuracy = correct / total;
    final _LevelResult level = _resolveLevel(accuracy);

    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 32.h),
                      _buildAssessmentBadge(),
                      SizedBox(height: 20.h),
                      _buildHero(level),
                      SizedBox(height: 28.h),
                      _buildStatsRow(accuracy: accuracy, elapsed: elapsed),
                      SizedBox(height: 24.h),
                      _buildUnlockedTopics(level),
                      SizedBox(height: 16.h),
                    ],
                  ),
                ),
              ),
              _buildActions(context),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Sections ──────────────────────────────────────────────────────────────

  /// "Assessment Complete" pill badge at the very top.
  Widget _buildAssessmentBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.darkGray,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.secondaryDarkGray),
      ),
      child: Text(
        'Assessment Complete',
        style: TextStyle(
          color: AppColors.lightGray,
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  /// "YOU ARE" + trophy icon + "CERTIFIED" + level name + description.
  Widget _buildHero(_LevelResult level) {
    return Column(
      children: [
        Text(
          'YOU ARE',
          style: TextStyle(
            fontFamily: 'Orbitron',
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        SizedBox(height: 20.h),

        // ─ Trophy icon ─
        Container(
          width: 72.w,
          height: 72.w,
          decoration: BoxDecoration(
            color: level.accentColor.withValues(alpha: 0.12),
            shape: BoxShape.circle,
            border: Border.all(color: level.accentColor.withValues(alpha: 0.3), width: 1.5),
          ),
          child: Icon(level.icon, color: level.accentColor, size: 34.sp),
        ),
        SizedBox(height: 12.h),

        // ─ "CERTIFIED" badge ─
        Text(
          'CERTIFIED',
          style: TextStyle(
            color: level.accentColor,
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.0,
          ),
        ),
        SizedBox(height: 6.h),

        // ─ Level label ─
        Text(
          level.label,
          style: TextStyle(
            fontFamily: 'Orbitron',
            fontSize: 32.sp,
            fontWeight: FontWeight.w900,
            color: AppColors.white,
            letterSpacing: 1.5,
          ),
        ),
        SizedBox(height: 14.h),

        // ─ Description ─
        Text(
          level.description,
          style: AppStyles.regular13interLightGray,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Two stat boxes side-by-side: ACCURACY and PACE.
  Widget _buildStatsRow({required double accuracy, required Duration elapsed}) {
    final String accuracyLabel = '${(accuracy * 100).round()}%';
    final String paceLabel = _formatDuration(elapsed);

    return Row(
      children: [
        Expanded(child: _buildStatBox(icon: Icons.track_changes_outlined, label: 'ACCURACY', value: accuracyLabel)),
        SizedBox(width: 14.w),
        Expanded(child: _buildStatBox(icon: Icons.timer_outlined, label: 'PACE', value: paceLabel)),
      ],
    );
  }

  Widget _buildStatBox({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: AppColors.darkGray,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.secondaryDarkGray),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.lightGray, size: 18.sp),
          SizedBox(height: 6.h),
          Text(
            label,
            style: TextStyle(
              color: AppColors.lightGray,
              fontSize: 10.sp,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              color: AppColors.white,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// "UNLOCKED TOPICS" section with a 2-column grid of topic chips.
  Widget _buildUnlockedTopics(_LevelResult level) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'UNLOCKED TOPICS',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
        SizedBox(height: 14.h),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10.w,
          mainAxisSpacing: 10.h,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 3.5,
          children: level.topics
              .map((topic) => _buildTopicChip(topic, level.accentColor))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildTopicChip(String topic, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: AppColors.darkGray,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.secondaryDarkGray),
      ),
      child: Row(
        children: [
          Icon(Icons.check_box_outlined, color: color, size: 14.sp),
          SizedBox(width: 6.w),
          Expanded(
            child: Text(
              topic,
              style: TextStyle(
                color: AppColors.white,
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// CTA button + footer note.
  Widget _buildActions(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: () => _startLearning(context),
          child: Container(
            width: double.infinity,
            height: 52.h,
            decoration: BoxDecoration(
              color: AppColors.lightBlue,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Center(
              child: Text(
                'START LEARNING',
                style: TextStyle(
                  color: AppColors.midnightBlue,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          'SETTING UP YOUR LAB WORKSPACE...',
          style: TextStyle(
            color: AppColors.lightGray.withValues(alpha: 0.5),
            fontSize: 9.sp,
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

  /// Formats a [Duration] as "Xm Ys" (e.g. "12m 4s").
  String _formatDuration(Duration d) {
    final int minutes = d.inMinutes;
    final int seconds = d.inSeconds.remainder(60);
    return '${minutes}m ${seconds}s';
  }
}
