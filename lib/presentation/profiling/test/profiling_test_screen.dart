import 'dart:async';

import 'package:ar_chem_lab/core/routes/app_routes.dart';
import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:ar_chem_lab/core/theme/app_styles.dart';
import 'package:ar_chem_lab/presentation/profiling/test/quiz_question.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ProfilingTestScreen
//
// Displays 15 chemistry questions one at a time.
// Tracks:
//   • Current question index
//   • The user's selected answer for each question
//   • Elapsed time (started when the screen mounts, stopped on last question)
//
// On completion, navigates to ProfilingResultScreen with accuracy + duration.
// ─────────────────────────────────────────────────────────────────────────────

class ProfilingTestScreen extends StatefulWidget {
  const ProfilingTestScreen({super.key});

  @override
  State<ProfilingTestScreen> createState() => _ProfilingTestScreenState();
}

class _ProfilingTestScreenState extends State<ProfilingTestScreen> {
  // ─── Constants ─────────────────────────────────────────────────────────────

  static const List<String> _optionLabels = ['A', 'B', 'C', 'D'];
  final List<QuizQuestion> _questions = kChemistryQuestions;

  // ─── State ─────────────────────────────────────────────────────────────────

  int _currentIndex = 0;

  /// Maps question index → chosen answer index (-1 = not answered yet).
  late final List<int> _answers;

  // ─── Timer ─────────────────────────────────────────────────────────────────

  late final Stopwatch _stopwatch;
  late final Timer _ticker;

  // ─── Computed Properties ───────────────────────────────────────────────────

  QuizQuestion get _currentQuestion => _questions[_currentIndex];
  int get _selectedAnswer => _answers[_currentIndex];
  bool get _hasAnswered => _selectedAnswer >= 0;
  bool get _isLastQuestion => _currentIndex == _questions.length - 1;
  double get _progress => (_currentIndex) / _questions.length;

  // ─── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _answers = List.filled(_questions.length, -1);
    _stopwatch = Stopwatch()..start();
    // Tick every second to keep the stopwatch running precisely.
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {});
  }

  @override
  void dispose() {
    _ticker.cancel();
    _stopwatch.stop();
    super.dispose();
  }

  // ─── Actions ───────────────────────────────────────────────────────────────

  /// Called when the user selects an answer option.
  void _selectAnswer(int index) {
    if (_hasAnswered) return; // Prevent changing answer after selection.
    setState(() => _answers[_currentIndex] = index);
  }

  /// Moves to the next question, or finishes the test on the last question.
  void _nextQuestion() {
    if (!_hasAnswered) return;

    if (_isLastQuestion) {
      _finishTest();
    } else {
      setState(() => _currentIndex++);
    }
  }

  /// Stops the timer and navigates to the result screen.
  void _finishTest() {
    _stopwatch.stop();
    _ticker.cancel();

    final int correctCount = _answers.asMap().entries.where((entry) {
      final int questionIndex = entry.key;
      final int chosenAnswer = entry.value;
      return chosenAnswer == _questions[questionIndex].correctIndex;
    }).length;

    Navigator.pushReplacementNamed(
      context,
      AppRoutes.profilingResultScreen,
      arguments: {
        'correctAnswers': correctCount,
        'totalQuestions': _questions.length,
        'duration': _stopwatch.elapsed,
      },
    );
  }

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProgressBar(),
              SizedBox(height: 24.h),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: KeyedSubtree(
                    key: ValueKey<int>(_currentIndex),
                    child: _buildQuestionContent(),
                  ),
                ),
              ),
              _buildNextButton(),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Sections ──────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: AppColors.white, size: 20.sp),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Question ${_currentIndex + 1}',
        style: AppStyles.bold18whiteSecondary,
      ),
      centerTitle: false,
    );
  }

  /// "PROFICIENCY TEST  |  X% Complete" + filled bar.
  Widget _buildProgressBar() {
    final int percent = ((_currentIndex) / _questions.length * 100).round();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'PROFICIENCY TEST',
              style: TextStyle(
                color: AppColors.lightBlue,
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            Text('$percent% Complete', style: AppStyles.regular12graySecondary),
          ],
        ),
        SizedBox(height: 6.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(4.r),
          child: LinearProgressIndicator(
            value: _progress,
            backgroundColor: AppColors.darkGray,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.lightBlue),
            minHeight: 4.h,
          ),
        ),
      ],
    );
  }

  /// The question text, hint, and answer options.
  Widget _buildQuestionContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ─ Question ─
        Text(
          _currentQuestion.question,
          style: AppStyles.bold24whiteOrbitron.copyWith(fontSize: 20.sp),
        ),
        SizedBox(height: 12.h),

        // ─ Hint ─
        Text(_currentQuestion.hint, style: AppStyles.regular13interLightGray),
        SizedBox(height: 28.h),

        // ─ Options ─
        ..._currentQuestion.options.asMap().entries.map(
          (entry) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: _buildOptionCard(index: entry.key, text: entry.value),
          ),
        ),
      ],
    );
  }

  /// A single answer option card (A / B / C / D).
  Widget _buildOptionCard({required int index, required String text}) {
    final bool isSelected = _selectedAnswer == index;
    final bool isCorrect =
        _hasAnswered && index == _currentQuestion.correctIndex;
    final bool isWrong = _hasAnswered && isSelected && !isCorrect;

    // After answering: correct = green, wrong = red, rest = default.
    final Color borderColor = isCorrect
        ? const Color(0xFF5AC1B7)
        : isWrong
        ? Colors.redAccent
        : isSelected
        ? AppColors.lightBlue
        : Colors.transparent;

    final Color bgColor = isCorrect
        ? const Color(0xFF5AC1B7).withValues(alpha: 0.1)
        : isWrong
        ? Colors.redAccent.withValues(alpha: 0.1)
        : isSelected
        ? AppColors.lightBlue.withValues(alpha: 0.08)
        : AppColors.darkGray;

    return GestureDetector(
      onTap: () => _selectAnswer(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          children: [
            // ─ Letter badge ─
            Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.lightBlue.withValues(alpha: 0.2)
                    : AppColors.secondaryDarkGray,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Center(
                child: Text(
                  _optionLabels[index],
                  style: TextStyle(
                    color: isSelected
                        ? AppColors.lightBlue
                        : AppColors.lightGray,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(width: 14.w),

            // ─ Option text ─
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 15.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),

            // ─ Checkmark (selected only) ─
            if (isSelected)
              Icon(
                isCorrect ? Icons.check_circle : Icons.cancel,
                color: isCorrect ? const Color(0xFF5AC1B7) : Colors.redAccent,
                size: 20.sp,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    final bool isLast = _isLastQuestion;
    return GestureDetector(
      onTap: _hasAnswered ? _nextQuestion : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 52.h,
        decoration: BoxDecoration(
          color: _hasAnswered
              ? AppColors.lightBlue
              : AppColors.lightBlue.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Center(
          child: Text(
            isLast ? 'Submit Test' : 'Next Question',
            style: TextStyle(
              color: AppColors.midnightBlue,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
