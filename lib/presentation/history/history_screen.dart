import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:ar_chem_lab/core/theme/app_padding.dart';
import 'package:ar_chem_lab/core/theme/app_styles.dart';
import 'package:ar_chem_lab/presentation/history/experiment_data.dart';
import 'package:ar_chem_lab/presentation/widget/app_back_button.dart';
import 'package:ar_chem_lab/presentation/widget/history_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedFilterIndex = 0;

  final List<String> _filters = ["All", "Successful", "Failed", "Recent"];

  // Mock Data (Reflecting the Image)
  final List<ExperimentData> _experiments = [
    ExperimentData(
      title: "Water Formation",
      date: "Oct 24, 2026",
      duration: "2m 45s",
      status: ExperimentStatus.success,
    ),
    ExperimentData(
      title: "Produce CO2",
      date: "Oct 22, 2026",
      duration: "4m 12s",
      status: ExperimentStatus.success,
    ),
    ExperimentData(
      title: "Methane Synthesis",
      date: "Oct 20, 2026",
      duration: "N/A",
      status: ExperimentStatus.failed,
      reason: "Pressure Overload",
    ),
    ExperimentData(
      title: "Acid Neutralization",
      date: "Oct 18, 2026",
      duration: "N/A",
      status: ExperimentStatus.success,
      extraInfo: "PH Balanced",
    ),
  ];

  List<ExperimentData> get _filteredExperiments {
    return _experiments.where((exp) {
      // Filter by Search Text
      final query = _searchController.text.toLowerCase();
      final matchesSearch = exp.title.toLowerCase().contains(query);

      if (!matchesSearch) return false;

      // Filter by Chips
      if (_selectedFilterIndex == 1) {
        return exp.status == ExperimentStatus.success;
      } else if (_selectedFilterIndex == 2) {
        return exp.status == ExperimentStatus.failed;
      }
      
      return true; // "All" or "Recent" (Recent assumes the list is already ordered)
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _filteredExperiments;

    return Scaffold(
      backgroundColor: Colors.black, // Dark background as per design
      body: SafeArea(
        child: Padding(
          padding: AppPadding.screen,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              SizedBox(height: 24.h),
              _buildSearchBar(),
              SizedBox(height: 24.h),
              _buildFilterChips(),
              SizedBox(height: 24.h),
              Text(
                "RECENT RECORDS",
                style: AppStyles.regular12graySecondary.copyWith(
                  letterSpacing: 1.2,
                  color: Colors.white60,
                ),
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredList.length,
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return HistoryCard(data: filteredList[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              "EXPERIMENT ",
              style: AppStyles.bold18whiteOrbitron,
            ),
            Text(
              "HISTORY",
              style: AppStyles.bold18whiteOrbitron.copyWith(
                color: AppColors.lightBlue,
              ),
            ),
          ],
        ),
        AppBackButton()
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkGray,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.lowSaturationGray),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => setState(() {}),
        style: AppStyles.medium14whiteInter,
        decoration: InputDecoration(
          hintText: "Search archive...",
          hintStyle: AppStyles.regular13interLightGray.copyWith(color: AppColors.lightBlue),
          prefixIcon: Icon(Icons.search, color: AppColors.lightBlue, size: 20.sp),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12.h),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 40.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedFilterIndex == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilterIndex = index),
            child: Container(
              margin: EdgeInsets.only(right: 12.w),
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.lightBlue : AppColors.darkGray,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Colors.transparent : Colors.white12,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                _filters[index],
                style: AppStyles.bold14whiteInter.copyWith(
                  color: isSelected ? Colors.black : Colors.white,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
