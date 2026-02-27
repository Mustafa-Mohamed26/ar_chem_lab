import 'package:ar_chem_lab/core/constants/app_assets.dart';
import 'package:ar_chem_lab/core/routes/app_routes.dart';
import 'package:ar_chem_lab/core/services/view_history_service.dart';
import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:ar_chem_lab/core/theme/app_gradients.dart';
import 'package:ar_chem_lab/core/theme/app_padding.dart';
import 'package:ar_chem_lab/core/theme/app_styles.dart';
import 'package:ar_chem_lab/presentation/periodic_table/element_tile.dart';
import 'package:ar_chem_lab/presentation/widget/gradient_bottom_nav_bar.dart';
import 'package:ar_chem_lab/presentation/widget/gradient_container.dart';
import 'package:ar_chem_lab/presentation/widget/user_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppGradients.primary(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.midnightBlue, AppColors.royalBlue],
          stops: [0, 1.0],
        ),
      ),
      child: Scaffold(
        bottomNavigationBar: GradientBottomNavBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: AppPadding.screen,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserHeader(
                  imageUrl: AppAssets.userImage,
                  title: "HAY MARK",
                  subtitle: "Ready for today's experiment?",
                ),
                SizedBox(height: 20.h),
                GradientContainer(
                  title: "Periodic Table",
                  subtitle: "Explore all chemical elements visually",
                  imagePath: AppAssets.atomImage,
                  subImagePath: AppAssets.rightArrowImage,
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.periodicTableScreen);
                  },
                ),
                SizedBox(height: 20.h),
                GradientContainer(
                  title: "AI Suggestions",
                  subtitle: "Personalized chemistry recommendations",
                  imagePath: AppAssets.testTubeImage,
                  subImagePath: AppAssets.rightArrowImage,
                  onTap: () {},
                ),
                SizedBox(height: 10.h),
                Text(
                  "Most Viewed Elements",
                  style: AppStyles.bold32whitePrimary,
                ),
                SizedBox(height: 10.h),
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
      ),
    );
  }
}
