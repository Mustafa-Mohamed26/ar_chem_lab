import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:ar_chem_lab/core/theme/app_styles.dart';
import 'package:ar_chem_lab/presentation/profiling/steps/profiling_step1_goal.dart';
import 'package:ar_chem_lab/presentation/profiling/steps/profiling_step2_education.dart';
import 'package:ar_chem_lab/presentation/profiling/steps/profiling_step3_knowledge.dart';
import 'package:ar_chem_lab/presentation/profiling/steps/profiling_step4_assessment.dart';
import 'package:ar_chem_lab/presentation/profiling/widgets/profiling_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ─────────────────────────────────────────────────────────────────────────────
// UserProfilingScreen
//
// Coordinator for the 4-step user profiling flow shown after registration.
//
// Selection state for all steps is stored here (lifted state), so that
// navigating back to a previous step restores the user's previous choice.
//
// Each step's UI lives in its own file under steps/:
//   • profiling_step1_goal.dart       — Why do you want to learn chemistry?
//   • profiling_step2_education.dart  — What is your education level?
//   • profiling_step3_knowledge.dart  — What is your knowledge level?
//   • profiling_step4_assessment.dart — Placement test overview
// ─────────────────────────────────────────────────────────────────────────────

class UserProfilingScreen extends StatefulWidget {
  const UserProfilingScreen({super.key});

  @override
  State<UserProfilingScreen> createState() => _UserProfilingScreenState();
}

class _UserProfilingScreenState extends State<UserProfilingScreen> {
  // ─── Constants ─────────────────────────────────────────────────────────────

  /// Total number of steps in the profiling flow.
  static const int _totalSteps = 4;

  /// Labels shown in the AppBar for each step (1-indexed).
  static const List<String> _stepTitles = [
    'Personalize', // Step 1
    'Education', // Step 2
    'Proficiency', // Step 3
    'Level Assess', // Step 4
  ];

  // ─── Step State ────────────────────────────────────────────────────────────

  /// The currently visible step (starts at 1).
  int _currentStep = 1;

  // ─── Selections (Lifted State) ─────────────────────────────────────────────
  //
  // Stored here instead of inside each step widget so that going back to a
  // previous step always restores the user's previous choice.
  // -1 means "nothing selected yet".

  /// Selected index for Step 1 — learning goal.
  int _selectedGoal = -1;

  /// Selected index for Step 2 — education level.
  int _selectedLevel = -1;

  /// Selected index for Step 3 — knowledge level.
  int _selectedKnowledge = -1;

  // ─── Computed Properties ───────────────────────────────────────────────────

  /// Title for the current step, shown in the AppBar.
  String get _currentTitle => _stepTitles[_currentStep - 1];

  /// Whether the user is on the very first step.
  bool get _isFirstStep => _currentStep == 1;

  // ─── Navigation ────────────────────────────────────────────────────────────

  /// Advance to the next step in the flow.
  void _nextStep() {
    if (_currentStep < _totalSteps) {
      setState(() => _currentStep++);
    }
  }

  /// Go back one step, or pop the screen if already on Step 1.
  void _previousStep() {
    if (!_isFirstStep) {
      setState(() => _currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  // ─── Step Factory ──────────────────────────────────────────────────────────

  /// Builds the widget for the current step, passing down selection state
  /// so each step knows what was previously chosen.
  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 1:
        return ProfilingStep1Goal(
          selectedIndex: _selectedGoal,
          onSelectionChanged: (i) => setState(() => _selectedGoal = i),
          onNext: _nextStep,
        );
      case 2:
        return ProfilingStep2Education(
          selectedIndex: _selectedLevel,
          onSelectionChanged: (i) => setState(() => _selectedLevel = i),
          onNext: _nextStep,
        );
      case 3:
        return ProfilingStep3Knowledge(
          selectedIndex: _selectedKnowledge,
          onSelectionChanged: (i) => setState(() => _selectedKnowledge = i),
          onNext: _nextStep,
        );
      case 4:
        // Step 4 has no selection — it navigates directly to HomeScreen.
        return const ProfilingStep4Assessment();
      default:
        return const SizedBox.shrink();
    }
  }

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              // Shared progress indicator at the top of every step
              _buildProgressBar(),
              SizedBox(height: 32.h),

              // Step content — animated when switching steps
              Expanded(child: _buildAnimatedStep()),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Sections ──────────────────────────────────────────────────────────────

  /// AppBar with a dynamic title and a back / close button.
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: AppColors.white, size: 20.sp),
        onPressed: _previousStep,
        tooltip: 'Go back',
      ),
      title: Text(_currentTitle, style: AppStyles.bold18whiteSecondary),
      centerTitle: false,
    );
  }

  /// Progress bar showing "STEP X OF 4" and a filled indicator.
  Widget _buildProgressBar() {
    return ProfilingProgressBar(
      currentStep: _currentStep,
      totalSteps: _totalSteps,
      label: _currentTitle,
    );
  }

  /// Wraps the current step in a fade + slide animation.
  /// [ValueKey] forces [AnimatedSwitcher] to rebuild when [_currentStep]
  /// changes, triggering the transition.
  Widget _buildAnimatedStep() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.05, 0), // subtle slide from the right
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: KeyedSubtree(
        key: ValueKey<int>(_currentStep),
        child: _buildCurrentStep(),
      ),
    );
  }
}
