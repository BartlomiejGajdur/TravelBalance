import 'package:TravelBalance/Utils/blur_dialog.dart';
import 'package:TravelBalance/Utils/globals.dart';
import 'package:TravelBalance/providers/user_provider.dart';
import 'package:country_picker/country_picker.dart';
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
        icon = Icons.airplanemode_active;
        break;
      case StatisticsTileType.countriesVisited:
        icon = Icons.public;
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

    final user = userProvider.user!;

    switch (statisticsTileType) {
      case StatisticsTileType.totalTrips:
        statistic = user.trips.length.toString();
        break;
      case StatisticsTileType.countriesVisited:
        statistic = user.getVisitedCountries().length.toString();
        break;
      case StatisticsTileType.spendings:
        statistic =
            '${user.getWholeExpenses().toStringAsFixed(2)}${user.baseCurrency.symbol}';

        break;
    }

    return Text(
      statistic,
      style: GoogleFonts.outfit(
        fontSize: 12.sp,
        color: secondaryTextColor,
        fontWeight: FontWeight.w600,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  void _showVisitedCountriesDialog(
      BuildContext context, UserProvider userProvider) {
    int sizeOfCountries = userProvider.user!.getVisitedCountries().length;
    double offset = 50.h;
    double calculateHeight = sizeOfCountries * 61.h + offset;

    // Upewnij się, że wysokość nie przekracza 700.h
    if (calculateHeight > 500.h) {
      calculateHeight = 500.h;
    }

    showBlurDialog(
      context: context,
      barrierDismissible: true,
      childBuilder: (ctx) {
        return Container(
          height: calculateHeight,
          width: 350.w,
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: calculateHeight - offset,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: sizeOfCountries,
              itemBuilder: (context, index) {
                final Country country =
                    userProvider.user!.getVisitedCountries().elementAt(index);
                return Card(
                  color: thirdColor.withOpacity(0.4),
                  child: ListTile(
                    leading: Text(country.flagEmoji),
                    title: Text(country.displayNameNoCountryCode),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatisticContainer(
      BuildContext context, UserProvider userProvider) {
    return GestureDetector(
      onTap: () {
        if (statisticsTileType == StatisticsTileType.countriesVisited &&
            userProvider.user!.getVisitedCountries().isNotEmpty) {
          _showVisitedCountriesDialog(context, userProvider);
        }
      },
      child: Container(
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Column(
      children: [
        _buildTitle(),
        SizedBox(height: 4.h),
        _buildStatisticContainer(context, userProvider),
      ],
    );
  }
}
