import 'package:TravelBalance/Utils/blur_dialog.dart';
import 'package:TravelBalance/Utils/globals.dart';
import 'package:TravelBalance/models/trip.dart';
import 'package:TravelBalance/providers/user_provider.dart';
import 'package:TravelBalance/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void deleteTrip(BuildContext context, Trip trip, int indexInList) {
  Navigator.of(context).pop();
  Provider.of<UserProvider>(context, listen: false).deleteTrip(indexInList);
  ApiService().deleteTrip(trip.id);
}

void showDeleteTripDialog(BuildContext context, Trip trip, int indexInList) {
  final String tripName = trip.name;

  showBlurDialog(
    context: context,
    barrierDismissible: true,
    childBuilder: (ctx) => SizedBox(
      height: 350.h,
      width: 335.w,
      child: Column(
        children: [
          SizedBox(height: 25.h),
          SvgPicture.asset(
            "lib/assets/RedBin.svg",
            height: 120.h,
            width: 120.w,
          ),
          SizedBox(height: 22.h),
          Text(
            "Tearing down the tent?",
            style: mainTextStyle,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 35.0.w),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: GoogleFonts.outfit(
                  fontSize: 16.sp,
                  color: secondaryTextColor,
                ),
                children: [
                  const TextSpan(text: "Once"),
                  TextSpan(
                    text: " $tripName",
                    style: const TextStyle(
                        color: primaryColor, fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(text: " trip is gone, it's gone for good."),
                ],
              ),
            ),
          ),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  deleteTrip(ctx, trip, indexInList);
                },
                child: Container(
                  height: 46.h,
                  width: 120.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    color: const Color(0xFFED5E68),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Delete",
                    style: buttonTextStyle,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(ctx).pop(),
                child: Container(
                  height: 46.h,
                  width: 120.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      color: const Color(0xffe8388a4)),
                  child: Text("Cancel", style: buttonTextStyle),
                ),
              ),
            ],
          ),
          SizedBox(height: 25.h),
        ],
      ),
    ),
  );
}
