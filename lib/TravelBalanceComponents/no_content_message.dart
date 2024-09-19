import 'package:TravelBalance/Utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

enum ContentType {
  Trips,
  Expenses,
}

Widget noContentMessage(ContentType contentType) {
  final String mainText = contentType == ContentType.Trips
      ? "No trips here yet."
      : "All quiet here.";
  String secondaryText = "Tap the plus button below to ";
  secondaryText += contentType == ContentType.Trips
      ? "create a\nnew trip."
      : "begin your expense\ntracking journey.";

  return Column(
    children: [
      SizedBox(height: 112.h),
      Text(mainText, style: mainTextStyle),
      SizedBox(height: 23.h),
      Text(secondaryText,
          style: secondaryTextStyle, textAlign: TextAlign.center),
      SizedBox(height: 70.h),
      SvgPicture.asset("lib/assets/ArrowDown.svg"),
    ],
  );
}
