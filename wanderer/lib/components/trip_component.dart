import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:wanderer/components/globals.dart';
import 'package:wanderer/models/trip.dart';

class TripComponent extends StatelessWidget {
  final Trip trip;
  final void Function() moveToDetails;
  final Function(BuildContext)? deleteFunction;

  const TripComponent({
    super.key,
    required this.trip,
    required this.moveToDetails,
    required this.deleteFunction,
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
                onPressed: deleteFunction,
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
                      trip.image ??
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
                              WidgetStateProperty.all(leadingColor),
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
