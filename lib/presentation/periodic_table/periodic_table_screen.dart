import 'package:ar_chem_lab/config/di/di.dart';
import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:ar_chem_lab/core/theme/app_gradients.dart';
import 'package:ar_chem_lab/core/theme/app_padding.dart';
import 'package:ar_chem_lab/core/theme/app_styles.dart';
import 'package:ar_chem_lab/domain/entities/periodic_table_response.dart';
import 'package:ar_chem_lab/presentation/periodic_table/cubit/periodic_table_states.dart';
import 'package:ar_chem_lab/presentation/periodic_table/cubit/periodic_table_view_model.dart';
import 'package:ar_chem_lab/presentation/periodic_table/element_tile.dart';
import 'package:ar_chem_lab/presentation/widget/screen_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PeriodicTableScreen extends StatefulWidget {
  const PeriodicTableScreen({super.key});

  @override
  State<PeriodicTableScreen> createState() => _PeriodicTableScreenState();
}

class _PeriodicTableScreenState extends State<PeriodicTableScreen> {
  late PeriodicTableViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<PeriodicTableViewModel>();
    _viewModel.getPeriodicTable();
  }

  Map<int, Map<int, PeriodicTableResponse>> _initializeGrid(
    List<PeriodicTableResponse> elements,
  ) {
    final Map<int, Map<int, PeriodicTableResponse>> gridMap = {};
    for (var element in elements) {
      if (!gridMap.containsKey(element.y)) {
        gridMap[element.y] = {};
      }
      gridMap[element.y]![element.x] = element;
    }
    return gridMap;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppGradients.primary(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.midnightBlue, AppColors.royalBlue],
        ),
      ),
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: AppPadding.screen,
              child: const ScreenTitle(title: "Atomic-Periodic Table"),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: BlocBuilder<PeriodicTableViewModel, PeriodicTableState>(
                key: const ValueKey('periodic_table_builder'),
                bloc: _viewModel,
                builder: (context, state) {
                  if (state is PeriodicTableLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.white),
                    );
                  } else if (state is PeriodicTableError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.message,
                            style: AppStyles.regular16WiteSecondary,
                          ),
                          SizedBox(height: 20.h),
                          ElevatedButton(
                            onPressed: () => _viewModel.getPeriodicTable(),
                            child: const Text("Retry"),
                          ),
                        ],
                      ),
                    );
                  } else if (state is PeriodicTableSuccess) {
                    final gridMap = _initializeGrid(state.elements);
                    return InteractiveViewer(
                      boundaryMargin: const EdgeInsets.all(100),
                      minScale: 0.1,
                      maxScale: 3.0,
                      constrained: false, // Allow infinite scrolling space
                      // Optimization: RepaintBoundary isolates the canvas
                      child: RepaintBoundary(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildGroupLabels(),
                              _buildMainTable(gridMap),
                              SizedBox(height: 30.h),
                              _buildLanthanidesSeries(gridMap),
                              _buildActinidesSeries(gridMap),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// SECTION: Group Labels (1-18)
  Widget _buildGroupLabels() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: 30.w), // Spacing for period labels
        ...List.generate(18, (index) {
          return Container(
            width: 80.w,
            height: 30.h, // Fixed height for header
            margin: const EdgeInsets.all(2),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.lowSaturationWhite,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: AppColors.lowSaturationWhite),
            ),
            child: Text(
              '${index + 1}',
              style: AppStyles.regular16WiteSecondary,
            ),
          );
        }),
      ],
    );
  }

  /// SECTION: Main Table (Periods 1-7)
  Widget _buildMainTable(Map<int, Map<int, PeriodicTableResponse>> gridMap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(7, (index) {
        final period = index + 1;
        return _buildPeriodRow(period, gridMap);
      }),
    );
  }

  /// SECTION: Bottom Series (Lanthanides)
  Widget _buildLanthanidesSeries(
    Map<int, Map<int, PeriodicTableResponse>> gridMap,
  ) {
    return Padding(
      padding: EdgeInsets.only(
        left: 80.0 * 2 + 30.0.w,
      ), // Shift to align with Group 3 + Sidebar space
      child: _buildPeriodRow(9, gridMap),
    );
  }

  /// SECTION: Bottom Series (Actinides)
  Widget _buildActinidesSeries(
    Map<int, Map<int, PeriodicTableResponse>> gridMap,
  ) {
    return Padding(
      padding: EdgeInsets.only(
        left: 80.0 * 2 + 30.0.w,
      ), // Shift to align with Group 3 + Sidebar space
      child: _buildPeriodRow(10, gridMap),
    );
  }

  Widget _buildPeriodRow(
    int period,
    Map<int, Map<int, PeriodicTableResponse>> gridMap,
  ) {
    // Optimization: Check if the row exists in map
    final rowElements = gridMap[period];
    if (rowElements == null) return const SizedBox();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Period Label (Sidebar)
        Container(
          width: 30.w,
          height: 90.h,
          margin: EdgeInsets.only(right: 2.w, top: 2.h, bottom: 2.h),
          alignment: Alignment.center,
          decoration: period <= 7
              ? BoxDecoration(
                  color: AppColors.lowSaturationWhite,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppColors.lowSaturationWhite),
                )
              : null,
          child: period <= 7
              ? Text('$period', style: AppStyles.regular16WiteSecondary)
              : null, // Don't show number for Lanthanides/Actinides
        ),

        // Element Tiles
        ...List.generate(18, (index) {
          final col = index + 1;
          // Optimization: O(1) lookup
          final element = rowElements[col];

          if (element != null) {
            // RepaintBoundary on individual tiles is helpful if they animate individually,
            // but here the global boundary helps most with scrolling.
            return ElementTile(element: element);
          } else {
            return Container(
              width: 80.w,
              height: 90.h,
              margin: const EdgeInsets.all(2),
            );
          }
        }),
      ],
    );
  }
}
