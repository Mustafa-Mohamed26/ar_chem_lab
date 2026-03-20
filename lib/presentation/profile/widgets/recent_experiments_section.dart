import 'package:ar_chem_lab/core/theme/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecentExperimentsSection extends StatelessWidget {
  const RecentExperimentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final experiments = [
      _ExperimentItem(
        title: "Magnesium Combustion",
        date: "Oct 24, 2026",
        badge: "Verified",
        image: "assets/images/card_image_1.png",
      ),
      _ExperimentItem(
        title: "Titration Analysis",
        date: "Oct 20, 2026",
        badge: "Perfect",
        image: "assets/images/card_image_2.png",
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "RECENT EXPERIMENTS",
              style: AppStyles.bold12whiteSecondary.copyWith(
                color: Colors.white70,
                letterSpacing: 1.1,
              ),
            ),
            Text(
              "View All",
              style: AppStyles.semiBold12lightBlueInter,
            ),
          ],
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 190.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: experiments.length,
            itemBuilder: (context, index) {
              final item = experiments[index];
              return Container(
                width: 160.w,
                margin: EdgeInsets.only(right: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 110.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        image: DecorationImage(
                          image: AssetImage(item.image),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 8.h,
                            right: 8.w,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.4),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                item.badge,
                                style: AppStyles.bold10whitePrimary.copyWith(fontSize: 9.sp),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      item.title,
                      style: AppStyles.bold14whiteInter.copyWith(fontSize: 13.sp),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      item.date,
                      style: AppStyles.regular12graySecondary.copyWith(fontSize: 10.sp),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ExperimentItem {
  final String title;
  final String date;
  final String badge;
  final String image;

  _ExperimentItem({
    required this.title,
    required this.date,
    required this.badge,
    required this.image,
  });
}
