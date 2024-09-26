import 'dart:ui';
import 'package:TravelBalance/Utils/blur_dialog.dart';
import 'package:TravelBalance/providers/user_provider.dart';
import 'package:TravelBalance/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:TravelBalance/Utils/globals.dart';
import 'package:TravelBalance/models/trip.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TripComponent extends StatelessWidget {
  final Trip trip;
  final int indexInList;
  final void Function() moveToDetails;

  const TripComponent({
    super.key,
    required this.trip,
    required this.indexInList,
    required this.moveToDetails,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: moveToDetails,
      child: Padding(
        padding: EdgeInsets.only(left: 12.0.w, right: 12.0.w, top: 12.0.h),
        child: Slidable(
          endActionPane: ActionPane(
            motion: const StretchMotion(),
            children: [
              SlidableAction(
                onPressed: (context) =>
                    showDeleteTripDialog(context, trip, indexInList),
                backgroundColor: const Color(0xFFFE4A49),
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),
          child: Container(
            height: 200.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(2, 2),
                ),
              ],
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.r),
                      topRight: Radius.circular(12.r),
                    ),
                    child: Image.network(
                      'https://cdn.dribbble.com/users/476251/screenshots/2619255/attachments/523315/placeholder.png',
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            trip.name,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            "\$${trip.tripCost.toString()}",
                            style: TextStyle(
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: moveToDetails,
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(primaryColor),
                        ),
                        child: const Text(
                          "Details",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void deleteTrip(BuildContext context, Trip trip, int indexInList) {
  Provider.of<UserProvider>(context, listen: false).deleteTrip(indexInList);
  ApiService().deleteTrip(trip.id);
  Navigator.of(context).pop();
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
                      color: const Color(0xFFE8388A4)),
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
