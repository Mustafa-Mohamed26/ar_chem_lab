import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:ar_chem_lab/core/theme/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Assuming you're using screenutil for .w

class UserHeader extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final bool showBackButton;

  const UserHeader({
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
            Image.asset(
              imageUrl,
              // You might want to add width/height here to keep it consistent
              width: 50.w,
              height: 50.w,
            ),
            SizedBox(width: 12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Keeps the column tight
              children: [
                Text(title, style: AppStyles.bold20whitePrimary),
                Text(subtitle, style: AppStyles.regular13skyBlueSecondary),
              ],
            ),
            Spacer(),
            if (showBackButton)
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(18.r)),
                  gradient: LinearGradient(
                    colors: [ AppColors.royalBlue, AppColors.electricBlue,],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_forward, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
          ],
        ),
      ],
    );
  }
}
