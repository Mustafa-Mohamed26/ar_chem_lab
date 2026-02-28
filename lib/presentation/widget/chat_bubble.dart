import 'dart:ui';

import 'package:ar_chem_lab/core/constants/app_assets.dart';
import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:ar_chem_lab/core/theme/app_styles.dart';
import 'package:ar_chem_lab/presentation/chat_bot/thinking_dots.dart';
import 'package:ar_chem_lab/presentation/chat_bot/typewriter_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  final bool isThinking;
  final VoidCallback? onTypewriterUpdate;

  const ChatBubble({
    super.key,
    required this.text,
    required this.isUser,
    this.isThinking = false,
    this.onTypewriterUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) _buildBotAvatar(),
          if (!isUser) _littleBubble(),
          Flexible(
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(24.r)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color: AppColors.lowSaturationWhite,
                    borderRadius: BorderRadius.all(Radius.circular(24.r)),
                    border: Border.all(
                      color: AppColors.lowSaturationWhite,
                      width: 1.5,
                    ),
                  ),
                  child: isThinking
                      ? const ThinkingDots()
                      : isUser
                      ? Text(
                          text,
                          style: AppStyles.medium12whitePrimary.copyWith(
                            fontSize: 14.sp,
                          ),
                        )
                      : TypewriterText(
                          text: text,
                          onChanged: onTypewriterUpdate,
                          style: AppStyles.medium12whitePrimary.copyWith(
                            fontSize: 14.sp,
                          ),
                        ),
                ),
              ),
            ),
          ),
          if (isUser) _littleBubble(),
          if (isUser) _buildUserAvatar(),
        ],
      ),
    );
  }

  Widget _buildBotAvatar() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.lowSaturationWhite,
        border: Border.all(color: AppColors.lowSaturationWhite, width: 1.5),
      ),
      child: Image.asset(AppAssets.robotImage, width: 35.w, height: 35.w),
    );
  }

  Widget _buildUserAvatar() {
    return CircleAvatar(
      radius: 18.r,
      backgroundColor: AppColors.white,
      child: Icon(Icons.person, color: AppColors.darkBlue, size: 35.sp),
    );
  }

  Widget _littleBubble() {
    return Container(
      width: 8.w,
      height: 8.w,
      decoration: BoxDecoration(
        color: AppColors.lowSaturationWhite,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.lowSaturationWhite, width: 1.5),
      ),
    );
  }
}
