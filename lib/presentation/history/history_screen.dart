import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:ar_chem_lab/core/theme/app_gradients.dart';
import 'package:ar_chem_lab/core/theme/app_padding.dart';
import 'package:ar_chem_lab/presentation/history/experiment_data.dart';
import 'package:ar_chem_lab/presentation/widget/history_card.dart';
import 'package:ar_chem_lab/presentation/widget/screen_title.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data (Replace with API list later)
    final List<ExperimentData> experiments = [
      ExperimentData(
        title: "Base Reaction Test",
        date: "Dec 9, 2025",
        duration: "25min",
        status: ExperimentStatus.completed,
        pHStart: 3.5,
        pHEnd: 7.0,
      ),
      ExperimentData(
        title: "Crystal Growth Experiment",
        date: "Dec 9, 2025",
        duration: "25min",
        status: ExperimentStatus.inProgress,
        pHStart: 3.5,
        pHEnd: 7.0,
      ),
      ExperimentData(
        title: "Base Reaction Test",
        date: "Dec 9, 2025",
        duration: "25min",
        status: ExperimentStatus.incomplete,
        pHStart: 3.5,
        pHEnd: 7.0,
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        gradient: AppGradients.primary(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.midnightBlue, AppColors.royalBlue],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // Important to see the gradient
        body: Padding(
          padding: AppPadding.screen,
          child: Column(
            children: [
              const ScreenTitle(title: 'History'),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: experiments.length,
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return HistoryCard(data: experiments[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
