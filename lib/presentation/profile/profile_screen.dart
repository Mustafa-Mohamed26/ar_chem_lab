import 'package:ar_chem_lab/core/theme/app_padding.dart';
import 'package:ar_chem_lab/core/theme/app_styles.dart';
import 'package:ar_chem_lab/presentation/profile/widgets/profile_header.dart';
import 'package:ar_chem_lab/presentation/profile/widgets/profile_stats_card.dart';
import 'package:ar_chem_lab/presentation/profile/widgets/recent_experiments_section.dart';
import 'package:ar_chem_lab/presentation/profile/widgets/lab_access_card.dart';
import 'package:ar_chem_lab/presentation/profile/widgets/settings_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: AppPadding.screen,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ProfileHeader(
                  name: "Mike",
                  rank: "Advanced Lab Apprentice",
                ),
                SizedBox(height: 14.h),
                const ProfileStatsCard(
                  experimentsCount: 24,
                  labHours: 12.5,
                  masteredTopics: [
                    "Stoichiometry",
                    "Titration",
                    "Redox",
                    "Organic",
                  ],
                ),
                SizedBox(height: 32.h),
                const RecentExperimentsSection(),
                const LabAccessCard(
                  title: "Beginner Lab Access",
                  subtitle: "Unlocked at 90% Mastery",
                  progress: 0.9,
                ),
                SizedBox(height: 32.h),
                Text("ACCOUNT & SAFETY", style: AppStyles.bold12whiteInter),
                SizedBox(height: 16.h),
                SettingsTile(
                  icon: Icons.shield_outlined,
                  title: "Safety Guidelines",
                  onTap: () {},
                ),
                SettingsTile(
                  icon: Icons.help_outline,
                  title: "Help & Tutorials",
                  onTap: () {},
                ),
                SettingsTile(
                  icon: Icons.person_outline,
                  title: "Privacy & Security",
                  onTap: () {},
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
