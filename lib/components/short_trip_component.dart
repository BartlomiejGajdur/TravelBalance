import 'package:TravelBalance/Utils/delete_dialog.dart';
import 'package:TravelBalance/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:TravelBalance/Utils/globals.dart';
import 'package:TravelBalance/models/trip.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ShortTripComponent extends StatelessWidget {
  final Trip trip;
  final void Function() moveToDetails;

  const ShortTripComponent({
    super.key,
    required this.trip,
    required this.moveToDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: GestureDetector(
        onTap: moveToDetails,
        child: Padding(
          padding: EdgeInsets.only(
              left: 12.0.w, right: 12.0.w, bottom: 12.0.h, top: 3.h),
          child: Slidable(
            endActionPane: ActionPane(
              motion: const StretchMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) => showDeleteTripDialog(context, trip),
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 200.w,
                        child: Text(
                          trip.name,
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.sp,
                              color: const Color(0xFF292B2D)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${trip.tripCost.toStringAsFixed(2)}${Provider.of<UserProvider>(context, listen: false).user!.baseCurrency.symbol}',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                          color: primaryColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center, // Wyśrodkowanie tekstu
                      ),
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
