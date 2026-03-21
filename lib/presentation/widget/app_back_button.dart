import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.lowSaturationGray, width: 1.5),
        gradient: LinearGradient(
          colors: [AppColors.darkGray, AppColors.darkGray],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: IconButton(
        icon: Icon(
          Icons.arrow_forward_ios,
          color: Colors.lightBlue,
          size: 25.w,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
