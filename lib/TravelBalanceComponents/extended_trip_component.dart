import 'package:TravelBalance/Utils/date_picker.dart';
import 'package:TravelBalance/Utils/delete_dialog.dart';
import 'package:TravelBalance/models/custom_image.dart';
import 'package:TravelBalance/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:TravelBalance/Utils/globals.dart';
import 'package:TravelBalance/models/trip.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

extension convertFlag on String {
  String get toFlag {
    return (this).toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'),
        (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397));
  }
}

class ExtendedTripComponent extends StatelessWidget {
  final Trip trip;
  final void Function() moveToDetails;

  const ExtendedTripComponent({
    super.key,
    required this.trip,
    required this.moveToDetails,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: moveToDetails,
      child: Padding(
        padding: EdgeInsets.only(
            left: 12.0.w, right: 12.0.w, bottom: 12.0.h, top: 3.h),
        child: Slidable(
          endActionPane: ActionPane(
            motion: const StretchMotion(),
            children: [
              SlidableAction(
                onPressed: (context) => showDeleteTripDialog(context, trip, false),
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
                  child: Stack(
                    children: [
                      // Obraz
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12.r),
                          topRight: Radius.circular(12.r),
                        ),
                        child: Image.asset(
                          getPathToImage(trip.customImage),
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Row(
                          children: [
                            for (var country in trip.countries)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(country.countryCode.toFlag,
                                      style: TextStyle(fontSize: 18.sp)),
                                  SizedBox(width: 6.w),
                                ],
                              ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0.w),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trip.name,
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF292B2D),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          formatDate(trip.dateTime),
                          style: GoogleFonts.inter(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF000000).withOpacity(0.5),
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          "${trip.sumOfEachExpenseCostInBaseCurrency().toStringAsFixed(2)}${Provider.of<UserProvider>(context, listen: false).user!.baseCurrency.symbol}",
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            color: primaryColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
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
