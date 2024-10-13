import 'package:TravelBalance/Utils/category_item.dart';
import 'package:TravelBalance/Utils/globals.dart';
import 'package:TravelBalance/models/expense.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ExpenseChart extends StatelessWidget {
  final Map<Category, double> categoriesWithMoney;
  final double totalTripCost;

  const ExpenseChart(
      {super.key,
      required this.categoriesWithMoney,
      required this.totalTripCost});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            height: 200.h,
            width: 200.w,
            child: Stack(alignment: Alignment.center, children: [
              PieChart(
                PieChartData(
                  sectionsSpace: 3,
                  centerSpaceColor: Colors.white,
                  sections: _buildPieChartSections(),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "\$$totalTripCost",
                    style: GoogleFonts.outfit(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: mainTextColor),
                  ),
                  Text("Current\nSpending",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w200,
                          color: secondaryTextColor))
                ],
              ),
            ]),
          ),
          _PieChartLegend()
        ],
      ),
    );
  }

  Widget _IconCategoryWithLabel(Category category) {
    String categoryName = Expense.staticCategoryToString(category);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        categoryIcon(category, 0.4),
        SizedBox(width: 4.w),
        Text(categoryName)
      ],
    );
  }

  Widget _PieChartLegend() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _IconCategoryWithLabel(Category.activities),
        SizedBox(height: 3.h),
        _IconCategoryWithLabel(Category.accommodation),
        SizedBox(height: 3.h),
        _IconCategoryWithLabel(Category.food),
        SizedBox(height: 3.h),
        _IconCategoryWithLabel(Category.health),
        SizedBox(height: 3.h),
        _IconCategoryWithLabel(Category.shopping),
        SizedBox(height: 3.h),
        _IconCategoryWithLabel(Category.transport),
        SizedBox(height: 3.h),
        _IconCategoryWithLabel(Category.souvenirs),
        SizedBox(height: 3.h),
        _IconCategoryWithLabel(Category.others),
      ],
    );
  }

  List<PieChartSectionData> _buildPieChartSections() {
    return categoriesWithMoney.entries.map((entry) {
      final Category category = entry.key;
      final double amount = entry.value;

      final sectionData = PieChartSectionData(
          value: amount,
          color: getCategoryColor(category).withOpacity(0.5),
          title: amount.toStringAsFixed(2),
          titleStyle: GoogleFonts.outfit(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          radius: 43.r);
      return sectionData;
    }).toList();
  }
}
