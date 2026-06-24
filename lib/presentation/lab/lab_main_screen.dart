import 'package:ar_chem_lab/core/constants/app_assets.dart';
import 'package:ar_chem_lab/core/routes/app_routes.dart';
import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:ar_chem_lab/core/theme/app_styles.dart';
import 'package:ar_chem_lab/domain/entities/lab/experiment_entity.dart';
import 'package:ar_chem_lab/domain/entities/lab/lab_level_entity.dart';
import 'package:ar_chem_lab/presentation/lab/widgets/lab_level_card.dart';
import 'package:ar_chem_lab/presentation/widget/app_back_button.dart';
import 'package:ar_chem_lab/presentation/auth/cubit/auth_view_model.dart';
import 'package:ar_chem_lab/presentation/auth/cubit/auth_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LabMainScreen extends StatelessWidget {
  const LabMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: BlocBuilder<AuthViewModel, AuthState>(
          builder: (context, state) {
            String userLevel = 'beginner';
            if (state is ProfileSuccess) {
              userLevel = state.user.level.toLowerCase();
            }

            final levels = _getDummyLevels(userLevel);

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(AppAssets.appLogo, height: 46.h),
                        SizedBox(width: 8.w),
                        Text("AR CHEM", style: AppStyles.bold18whiteOrbitron),
                      ],
                    ),
                    const AppBackButton(),
                  ],
                ),
                SizedBox(height: 24.h),
                Text(
                  "Chemistry Progression",
                  style: AppStyles.bold24whiteOrbitron,
                ),
                SizedBox(height: 8.h),
                Text(
                  "unlock new experimental modules by completing prerequisites.",
                  style: AppStyles.regular13interLightGray,
                ),
                SizedBox(height: 32.h),
                ...levels.map(
                  (level) => LabLevelCard(
                    level: level,
                    onStart: () {
                      if (level.experiments.isNotEmpty) {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.experimentDetailScreen,
                          arguments: level.experiments.first,
                        );
                      }
                    },
                  ),
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        );
      }),
      ),
    );
  }

  List<LabLevelEntity> _getDummyLevels(String userLevel) {
    final isIntermediateOpen = userLevel == 'intermediate' || userLevel == 'expert';

    return [
      LabLevelEntity(
        id: "1",
        title: "Beginner level",
        description:
            "Master the molecular basics. Learn laboratory safety, basic reactions, and compound identification through guided interactive simulations.",
        status: LabLevelStatus.active,
        progress: 0.75,
        experiments: [
          ExperimentEntity(
            id: "e1",
            title: "Fundamentals of Chemistry",
            description:
                "Learn the basics of Volumetric measurements and safety protocols in a controlled AR environment",
            time: "15 min",
            exp: "4 Steps",
            safety: ExperimentSafety.high,
            materials: [
              const ExperimentMaterial(name: "Beaker", icon: "beaker"),
              const ExperimentMaterial(name: "Pipette", icon: "pipette"),
              const ExperimentMaterial(name: "Test Tube", icon: "testTube"),
              const ExperimentMaterial(name: "Heat Source", icon: "heat"),
            ],
            path: [
              const ExperimentStep(
                title: "Measure Reactants",
                description:
                    "Precisely measure 50ml of solution A using the graduated cylinder.",
              ),
              const ExperimentStep(
                title: "Observe Reaction",
                description:
                    "Monitor temperature changes as the exothermic reaction stabilizes.",
              ),
            ],
            tip:
                "Ensure you are in well-lit area for the most accurate equipment tracking during the experiment",
          ),
        ],
      ),
      LabLevelEntity(
        id: "2",
        title: "Intermediate level",
        description:
            "Full access to the Quantum Lab. Design your own molecules, run sub-atomic stability tests, and contribute to the global leaderboard.",
        status: isIntermediateOpen ? LabLevelStatus.active : LabLevelStatus.locked,
        progress: 0.0,
        experiments: const [],
        prerequisite: "Beginner : Organic Synthesis",
      ),
    ];
  }
}
