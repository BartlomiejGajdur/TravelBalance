import 'package:TravelBalance/Utils/globals.dart';
import 'package:TravelBalance/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

enum StatisticsTileType { totalTrips, countriesVisited, spendings }

class StatisticsTile extends StatelessWidget {
  final StatisticsTileType statisticsTileType;

  const StatisticsTile({super.key, required this.statisticsTileType});

  // Method to get the title as a styled text widget
  Widget _buildTitle() {
    String title;
    switch (statisticsTileType) {
      case StatisticsTileType.totalTrips:
        title = 'Total Trips';
        break;
      case StatisticsTileType.countriesVisited:
        title = 'Countries Visited';
        break;
      case StatisticsTileType.spendings:
        title = 'Total Spendings';
        break;
    }

    return Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: 12.sp,
        color: secondaryTextColor,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  // Method to get the appropriate icon based on the statistics type
  Widget _buildIcon() {
    IconData icon;
    switch (statisticsTileType) {
      case StatisticsTileType.totalTrips:
        icon = Icons.twenty_mp_outlined;
        break;
      case StatisticsTileType.countriesVisited:
        icon = Icons.wallet;
        break;
      case StatisticsTileType.spendings:
        icon = Icons.wallet;
        break;
    }

    return Icon(
      icon,
      color: primaryColor,
      size: 40,
    );
  }

  // Method to get the statistic value formatted as text
  Widget _buildStatistic(UserProvider userProvider) {
    String statistic;
    final statistics = userProvider.user!.statistics;

    switch (statisticsTileType) {
      case StatisticsTileType.totalTrips:
        statistic = userProvider.user!.trips.length.toString();
        break;
      case StatisticsTileType.countriesVisited:
        statistic = statistics.visitedCountriesAmount.toString();
        break;
      case StatisticsTileType.spendings:
        statistic = '${userProvider.user!.getWholeExpenses().toString()}\$';
        break;
    }

    return Text(
      statistic,
      style: GoogleFonts.outfit(
        fontSize: 12.sp,
        color: secondaryTextColor,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildStatisticContainer(UserProvider userProvider) {
    return Container(
      height: 85.h,
      width: 85.w,
      decoration: BoxDecoration(
        color: const Color(0xFF92A332).withOpacity(0.2),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildIcon(),
          SizedBox(height: 4.h),
          _buildStatistic(userProvider),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Column(
      children: [
        _buildTitle(),
        _buildStatisticContainer(userProvider),
      ],
    );
  }
}
