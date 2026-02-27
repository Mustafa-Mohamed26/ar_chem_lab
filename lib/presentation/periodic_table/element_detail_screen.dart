import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:ar_chem_lab/core/theme/app_gradients.dart';
import 'package:ar_chem_lab/core/theme/app_styles.dart';
import 'package:ar_chem_lab/presentation/periodic_table/element_model.dart';
import 'package:ar_chem_lab/presentation/widget/gradient_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ElementDetailScreen extends StatefulWidget {
  const ElementDetailScreen({super.key});

  @override
  State<ElementDetailScreen> createState() => _ElementDetailScreenState();
}

class _ElementDetailScreenState extends State<ElementDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Extract arguments
    final element = ModalRoute.of(context)!.settings.arguments as ElementModel;

    return Scaffold(
      backgroundColor: AppColors.midnightBlue,
      body: Container(
        decoration: BoxDecoration(
          gradient: AppGradients.primary(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.midnightBlue, AppColors.royalBlue],
          ),
        ),
        child: Column(
          children: [
            _buildSymbolHeader(context, element),
            _buildStatsRow(element),
            SizedBox(height: 20.h),
            _buildTabBar(),
            Expanded(child: _buildTabBarView(element)),
          ],
        ),
      ),
    );
  }

  Widget _buildSymbolHeader(BuildContext context, ElementModel element) {
    return SizedBox(
      height: 350.h,
      child: Stack(
        children: [
          // Background Symbol (Big and Faded)
          Positioned.fill(
            child: Center(
              child: Opacity(
                opacity: 0.1,
                child: Text(
                  element.symbol,
                  style: TextStyle(
                    fontSize: 300.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          // Main Content Centered
          Center(
            child: Hero(
              tag: 'element_symbol_${element.symbol}',
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 180.w,
                  height: 180.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: element.color.withOpacity(0.5),
                        blurRadius: 50,
                        spreadRadius: 10,
                      ),
                    ],
                    gradient: RadialGradient(
                      colors: [
                        element.color.withOpacity(0.8),
                        element.color.withOpacity(0.2),
                      ],
                    ),
                    border: Border.all(color: Colors.white30, width: 2),
                  ),
                  child: Text(
                    element.symbol,
                    style: AppStyles.bold32whitePrimary.copyWith(
                      fontSize: 80.sp,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Back Button
          Positioned(
            top: 40.h,
            left: 310.w,
            child: GradientBackButton()
          ),

          // Element Info Card Overlay
          Positioned(
            bottom: 20.h,
            left: 20.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: AppColors.lowSaturationWhite,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.lowSaturationWhite),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(element.name, style: AppStyles.bold24whitePrimary),
                  Text(
                    element.symbol,
                    style: AppStyles.bold35whitePrimary
                  ),
                  Text(
                    "${element.atomicMass} (g/mol)",
                    style: AppStyles.regular14LightBlueSecondary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(ElementModel element) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.lowSaturationWhite,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem("Electron", "${element.electrons}"),
          Container(height: 30.h, width: 1, color: AppColors.white),
          _buildStatItem("Proton", "${element.protons}"),
          Container(height: 30.h, width: 1, color: AppColors.white),
          _buildStatItem("Neutron", "${element.neutrons}"),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: AppStyles.bold18whitePrimary),
        SizedBox(height: 4.h),
        Text(value, style: AppStyles.bold18whitePrimary),
      ],
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Container(
        height: 40.h,
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(25),
        ),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            color: AppColors.royalBlue,
            borderRadius: BorderRadius.circular(25),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          labelColor: AppColors.white,
          unselectedLabelColor: AppColors.grey,
          labelStyle: AppStyles.bold16whiteSecondary,
          tabs: const [
            Tab(text: "Overview"),
            Tab(text: "Properties"),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBarView(ElementModel element) {
    return TabBarView(
      controller: _tabController,
      children: [
        // Overview Tab
        _buildOverviewTab(element),
        // Properties Tab (Placeholder for now)
        Center(
          child: Text(
            "Properties content coming soon",
            style: AppStyles.regular16WiteSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewTab(ElementModel element) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppColors.lowSaturationWhite,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.lowSaturationWhite),
        ),
        child: Column(
          children: [
            _buildDetailRow("Latin Name", element.latinName),
            _buildDetailRow("Density", "${element.density} (g/cm^3)"),
            _buildDetailRow("Atomic Number", "${element.atomicNumber}"),
            _buildDetailRow("Periodic Group", element.groupName),
            _buildDetailRow("Period", "${element.y}"),
            _buildDetailRow("Valence (Valency)", element.valence),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppStyles.bold16whiteSecondary),
          Text(
            value.isNotEmpty ? value : "N/A",
            style: AppStyles.bold16whiteSecondary,
          ),
        ],
      ),
    );
  }
}
