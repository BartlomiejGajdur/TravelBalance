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

  ExpenseChart(
      {super.key,
      required this.categoriesWithMoney,
      required this.totalTripCost});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(alignment: Alignment.center, children: [
        PieChart(
          PieChartData(
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
    );
  }

  List<PieChartSectionData> _buildPieChartSections() {
    return categoriesWithMoney.entries.map((entry) {
      final Category category = entry.key;
      final double amount = entry.value;

      final sectionData = PieChartSectionData(
        value: amount,
        color: getCategoryColor(category),
        title: '${amount.toStringAsFixed(2)}',
        titleStyle: GoogleFonts.outfit(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      );
      return sectionData;
    }).toList();
  }
}
