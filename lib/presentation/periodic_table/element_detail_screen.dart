import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:ar_chem_lab/core/theme/app_styles.dart';
import 'package:ar_chem_lab/domain/entities/periodic_table_response.dart';
import 'package:ar_chem_lab/presentation/periodic_table/widget/bohr_model_widget.dart';
import 'package:ar_chem_lab/presentation/widget/app_back_button.dart';
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
    // Extract arguments safely
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args == null || args is! PeriodicTableResponse) {
      return Scaffold(
        backgroundColor: AppColors.midnightBlue,
        body: Center(
          child: Text(
            "Element details not found",
            style: AppStyles.bold20whitePrimary,
          ),
        ),
      );
    }
    final PeriodicTableResponse element = args;

    return Scaffold(
      body: Column(
        children: [
          _buildSymbolHeader(context, element),
          _buildStatsRow(element),
          SizedBox(height: 20.h),
          _buildTabBar(),
          Expanded(child: _buildTabBarView(element)),
        ],
      ),
    );
  }

  Widget _buildSymbolHeader(
    BuildContext context,
    PeriodicTableResponse element,
  ) {
    return SizedBox(
      height: 350.h,
      child: Stack(
        children: [
          // Main Content Centered
          Center(
            child: BohrModelWidget(element: element),
          ),

          // Back Button
          Positioned(top: 40.h, left: 310.w, child: AppBackButton()),

          // Element Info Card Overlay
          Positioned(
            bottom: 20.h,
            left: 20.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: AppColors.darkGray,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.lowSaturationWhite),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(element.name, style: AppStyles.bold18whiteOrbitron),
                  Text(element.symbol, style: AppStyles.bold32whiteOrbitron),
                  Text(
                    "${element.atomicMass} (g/mol)",
                    style: AppStyles.regular14LightBlueInter,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(PeriodicTableResponse element) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.darkGray,
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
        Text(label, style: AppStyles.bold18whiteOrbitron),
        SizedBox(height: 4.h),
        Text(value, style: AppStyles.bold17whiteInter),
      ],
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Container(
        height: 40.h,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            color: AppColors.lightBlue,
            borderRadius: BorderRadius.circular(25),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          labelColor: AppColors.white,
          unselectedLabelColor: AppColors.lightBlue,
          labelStyle: AppStyles.bold16whiteSecondary,
          tabs: const [
            Tab(text: "Overview"),
            Tab(text: "Properties"),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBarView(PeriodicTableResponse element) {
    return TabBarView(
      controller: _tabController,
      children: [
        // Overview Tab
        _buildOverviewTab(element),
        // Properties Tab
        _buildPropertiesTab(element),
      ],
    );
  }

  Widget _buildOverviewTab(PeriodicTableResponse element) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppColors.darkGray,
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
            _buildDetailRow(
              "Melting Point",
              element.meltingPoint.isNotEmpty
                  ? "${element.meltingPoint} K"
                  : "N/A",
            ),
            _buildDetailRow(
              "Boiling Point",
              element.boilingPoint.isNotEmpty
                  ? "${element.boilingPoint} K"
                  : "N/A",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertiesTab(PeriodicTableResponse element) {
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
            _buildDetailRow(
              "Electronegativity",
              element.electronegativity?.toString() ?? "N/A",
            ),
            _buildDetailRow(
              "Atomic Radius",
              element.atomicRadius?.toString() ?? "N/A",
            ),
            _buildDetailRow(
              "Ionization Energy",
              element.ionizationEnergy?.toString() ?? "N/A",
            ),
            _buildDetailRow(
              "Electron Affinity",
              element.electronAffinity?.toString() ?? "N/A",
            ),
            _buildDetailRow(
              "Oxidation States",
              element.oxidationStates ?? "N/A",
            ),
            _buildDetailRow("Standard State", element.standardState ?? "N/A"),
            _buildDetailRow("Year Discovered", element.yearDiscovered),
            _buildDetailRow("Group Block", element.groupBlock ?? "N/A"),
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
