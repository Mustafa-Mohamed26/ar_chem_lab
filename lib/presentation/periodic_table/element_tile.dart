import 'package:ar_chem_lab/core/routes/app_routes.dart';
import 'package:ar_chem_lab/core/services/view_history_service.dart';
import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:ar_chem_lab/core/theme/app_styles.dart';
import 'package:ar_chem_lab/domain/entities/periodic_table_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ElementTile extends StatelessWidget {
  final PeriodicTableResponse element;
  const ElementTile({super.key, required this.element});

  @override
  Widget build(BuildContext context) {
    if (element.isEmpty) return SizedBox(width: 60.w, height: 70.h);

    return GestureDetector(
      onTap: () {
        ViewHistoryService().addElement(element);
        Navigator.pushNamed(
          context,
          AppRoutes.elementDetailScreen,
          arguments: element,
        );
      },
      child: RepaintBoundary(
        child: Container(
          width: 80.w,
          height: 90.h,
          margin: const EdgeInsets.all(2),
          decoration: _buildDecoration(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildAtomicNumber(),
              _buildSymbol(),
              _buildElementName(),
            ],
          ),
        ),
      ),
    );
  }

  /// SECTION: Decoration
  BoxDecoration _buildDecoration() {
    return BoxDecoration(
      color: element.color,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: AppColors.lowSaturationWhite, width: 4.w),
    );
  }

  /// SECTION: Content Widgets
  Widget _buildAtomicNumber() {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 4.w, top: 2.h),
        child: Text(
          '${element.atomicNumber}',
          style: AppStyles.bold10whitePrimary,
        ),
      ),
    );
  }

  Widget _buildSymbol() {
    return Expanded(
      child: Text(element.symbol, style: AppStyles.bold32whitePrimary),
    );
  }

  Widget _buildElementName() {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Text(
        element.name,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppStyles.bold12whitePrimary,
      ),
    );
  }
}
