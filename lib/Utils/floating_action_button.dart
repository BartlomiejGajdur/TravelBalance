import 'package:TravelBalance/Utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


Widget buildFloatingActionButton(BuildContext context, Function() func) {
  return Padding(
    padding: EdgeInsets.only(bottom: 30.0.h),
    child: FloatingActionButton(
      onPressed: func,
      backgroundColor: secondaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32.0.r),
      ),
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    ),
  );
}
