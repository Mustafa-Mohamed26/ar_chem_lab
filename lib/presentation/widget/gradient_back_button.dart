import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GradientBackButton extends StatelessWidget {
  const GradientBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(18.r)),
        gradient: LinearGradient(
          colors: [AppColors.royalBlue, AppColors.electricBlue],
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
    );
  }
}
