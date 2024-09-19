import 'package:TravelBalance/Utils/floating_action_button.dart';
import 'package:TravelBalance/Utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomScaffold extends StatelessWidget {
  final String text1;
  final String text2;
  final Widget childWidget;
  final Function()? onEditIconClick;
  final Function()? onActionButtonClick;

  const CustomScaffold({
    super.key,
    required this.text1,
    required this.text2,
    required this.childWidget,
    this.onEditIconClick,
    this.onActionButtonClick,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      body: Column(
        children: [
          SizedBox(height: 53.0.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back),
                color: Colors.white,
                alignment: Alignment.centerLeft,
                iconSize: 32,
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(text1, style: mainHeaderTextStyle),
                ),
              ),
              onEditIconClick != null
                  ? IconButton(
                      onPressed: onEditIconClick,
                      icon: const Icon(Icons.edit),
                      color: Colors.white,
                      alignment: Alignment.centerRight,
                      iconSize: 32,
                    )
                  : const SizedBox(width: 48),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.0.w),
            child: Align(
              alignment: Alignment.center,
              child: Text(text2, style: secondaryHeaderTextStyle),
            ),
          ),
          SizedBox(height: 19.0.h),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(21.0.r),
                    topRight: Radius.circular(21.0.r)),
              ),
              child: childWidget,
            ),
          ),
        ],
      ),
      floatingActionButton: onActionButtonClick != null
          ? buildFloatingActionButton(context, onActionButtonClick!)
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
