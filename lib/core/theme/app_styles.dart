import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppStyles {
  static TextStyle bold35white = GoogleFonts.oswald(
    fontSize: 35.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );
  static TextStyle bold32white = GoogleFonts.oswald(
    fontSize: 32.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static TextStyle bold20white = GoogleFonts.oswald(
    fontSize: 20.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static TextStyle regular18white = GoogleFonts.cairo(
    fontSize: 18.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.white,
  );

  static TextStyle bold18white = GoogleFonts.cairo(
    fontSize: 18.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static TextStyle regular13skyBlue = GoogleFonts.cairo(
    fontSize: 13.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.skyBlue,
  );
}