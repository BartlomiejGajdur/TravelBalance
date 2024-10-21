import 'package:TravelBalance/Utils/blur_dialog.dart';
import 'package:TravelBalance/Utils/globals.dart';
import 'package:TravelBalance/models/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

Widget chosenImage(CustomImage imagePicked) {
  final bool isPicked = imagePicked != CustomImage.defaultLandscape;
  return Stack(
    alignment: Alignment.center,
    children: [
      isPicked
          ? Image.asset(
              imageToName[imagePicked]!,
              fit: BoxFit.cover,
              height: 91.h,
              width: 107.w,
            )
          : SizedBox.shrink(),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image, size: 32.h, color: thirdColor),
          const SizedBox(height: 8),
          Text(
            "Image",
            style: GoogleFonts.outfit(fontSize: 16.sp, color: thirdColor),
          ),
        ],
      ),
    ],
  );
}

Widget imagePicker(BuildContext context, CustomImage imagePicked,
    Function(CustomImage) onImagePicked) {
  final bool isPicked = imagePicked != CustomImage.defaultLandscape;

  return GestureDetector(
    onTap: () => pickImage(context, imagePicked, onImagePicked),
    child: Container(
        height: 91.h,
        width: 107.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: isPicked ? null : const Color(0xFF92A332).withOpacity(0.2)),
        clipBehavior: Clip.hardEdge,
        child: chosenImage(imagePicked)),
  );
}

void pickImage(BuildContext context, CustomImage imagePicked,
    Function(CustomImage) onImagePicked) {
  debugPrint("clicked");
  showBlurDialog(
    context: context,
    childBuilder: (ctx) => Container(
      width: 350.w,
      height: 600.h,
      child: ListView.builder(
        itemCount: imageToName.length,
        itemBuilder: (ctx, index) {
          return GestureDetector(
              onTap: () {
                onImagePicked(CustomImage.values[index]);
                Navigator.of(ctx).pop();
              },
              child: ImageComponent(index, imagePicked));
        },
      ),
    ),
  );
}

Column ImageComponent(int index, CustomImage imagePicked) {
  bool customImageMatch = CustomImage.values[index] == imagePicked;

  return Column(
    children: [
      Container(
        height: 200.h,
        width: 300.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          border: customImageMatch
              ? Border.all(color: primaryColor, width: 4.0)
              : null,
        ),
        clipBehavior: Clip.hardEdge,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r), // Zaokrąglenie ramki
          child: Image.asset(
            imageToName[CustomImage.values[index]]!,
            fit: BoxFit.cover,
          ),
        ),
      ),
      SizedBox(height: 12.h),
    ],
  );
}
