import 'package:ar_chem_lab/core/routes/app_routes.dart';
import 'package:ar_chem_lab/core/theme/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Assuming you're using screenutil for .w

class HomeHeader extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final bool showBackButton;

  const HomeHeader({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20.h),
        Row(
          children: [
            GestureDetector(
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.profileScreen),
              child: Image.asset(
                imageUrl,
                // You might want to add width/height here to keep it consistent
                width: 50.w,
                height: 50.w,
              ),
            ),
            SizedBox(width: 12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Keeps the column tight
              children: [
                Text(title, style: AppStyles.regular12whiteInter),
                Text(subtitle, style: AppStyles.bold17whiteInter),
              ],
            ),
            Spacer(),
            if (showBackButton) const BackButton(),
          ],
        ),
      ],
    );
  }
}
