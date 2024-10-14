import 'package:TravelBalance/Utils/delete_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:TravelBalance/Utils/globals.dart';
import 'package:TravelBalance/models/trip.dart';
import 'package:google_fonts/google_fonts.dart';

class ShortTripComponent extends StatelessWidget {
  final Trip trip;
  final int indexInList;
  final void Function() moveToDetails;

  const ShortTripComponent({
    super.key,
    required this.trip,
    required this.indexInList,
    required this.moveToDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: GestureDetector(
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
                ),
              ],
            ),
            child: Container(
                height: 35.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(2, 2),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        trip.name,
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp,
                            color: const Color(0xFF292B2D)),
                      ),
                      Text(
                        '${trip.tripCost.toString()}\$',
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp,
                            color: primaryColor),
                      )
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
