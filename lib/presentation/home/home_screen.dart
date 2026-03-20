import 'package:ar_chem_lab/core/constants/app_assets.dart';
import 'package:ar_chem_lab/core/routes/app_routes.dart';
import 'package:ar_chem_lab/core/services/view_history_service.dart';
import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:ar_chem_lab/core/theme/app_gradients.dart';
import 'package:ar_chem_lab/core/theme/app_padding.dart';
import 'package:ar_chem_lab/core/theme/app_styles.dart';
import 'package:ar_chem_lab/presentation/home/widget/home_action_card.dart';
import 'package:ar_chem_lab/presentation/home/widget/home_header.dart';
import 'package:ar_chem_lab/presentation/home/widget/level_progress_card.dart';
import 'package:ar_chem_lab/presentation/periodic_table/element_tile.dart';
import 'package:ar_chem_lab/presentation/widget/gradient_bottom_nav_bar.dart';
import 'package:ar_chem_lab/presentation/widget/gradient_container.dart';
import 'package:ar_chem_lab/presentation/auth/cubit/auth_view_model.dart';
import 'package:ar_chem_lab/presentation/auth/cubit/auth_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger getProfile only once when the screen is first loaded
    context.read<AuthViewModel>().getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: GradientBottomNavBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: AppPadding.screen,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<AuthViewModel, AuthState>(
                builder: (context, state) {
                  String username = "...";
                  if (state is ProfileSuccess) {
                    username = state.user.username.toUpperCase();
                  } else if (state is AuthError) {
                    username = "ALCHEMIST";
                  }
                  return HomeHeader(
                    imageUrl: AppAssets.userImage,
                    title: "Welcome back,",
                    subtitle: username,
                  );
                },
              ),
              SizedBox(height: 20.h),
              Text(
                "Continue your chemistry journey and explore 12 new reactions today",
                style: AppStyles.bold14interWhite,
              ),
  
              SizedBox(height: 20.h),
              LevelProgressCard(
                level: "Intermediate",
                progress: 0.82,
                helperText: "Complete 3 more challenges to unlock Organic Chemistry modules.",
                onContinue: () {
                  Navigator.pushNamed(context, AppRoutes.labMainScreen);
                },
              ),
              SizedBox(height: 16.h),
              HomeActionCard(
                title: "Start AR Experiment",
                description: "Explore chemical reactions in augmented reality",
                iconPath: AppAssets.testTubeImage,
                actionIcon: Icons.play_arrow_rounded,
                onTap: () {
                   Navigator.pushNamed(context, AppRoutes.periodicTableScreen);
                },
              ),
              SizedBox(height: 16.h),
              HomeActionCard(
                title: "Periodic Table",
                description: "Explore all chemical elements visually",
                iconPath: AppAssets.atomImage,
                actionIcon: Icons.arrow_forward_ios_rounded,
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.periodicTableScreen);
                },
              ),
              SizedBox(height: 24.h),
              Text("Most Viewed Elements", style: AppStyles.bold22interWhite),
              SizedBox(height: 16.h),
              SizedBox(
                height: 100.h,
                child: ValueListenableBuilder(
                  valueListenable: ViewHistoryService().mostViewedElements,
                  builder: (context, history, child) {
                    if (history.isEmpty) {
                      return Center(
                        child: Text(
                          "No elements viewed yet.",
                          style: AppStyles.regular18whiteSecondary,
                        ),
                      );
                    }
                    // User wants "last element selected is added" and "first disapears"
                    // My service adds new to end and removes from start.
                    // So index 0 is oldest, last index is newest.
                    // We can reverse it for display if preferred,
                    // but I'll stick to the logical "newest at the end" for now
                    // unless it feels weird. Actually, reversing is usually better for "Recent".
                    final displayList = history.reversed.toList();

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: displayList.length,
                      itemBuilder: (context, index) {
                        return ElementTile(element: displayList[index]);
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
