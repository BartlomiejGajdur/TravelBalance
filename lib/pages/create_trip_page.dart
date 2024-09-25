import 'package:TravelBalance/TravelBalanceComponents/custom_button.dart';
import 'package:TravelBalance/TravelBalanceComponents/custom_text_form_field.dart';
import 'package:TravelBalance/Utils/custom_scaffold.dart';
import 'package:TravelBalance/Utils/globals.dart';
import 'package:TravelBalance/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CreateTripPage extends StatelessWidget {
  final TextEditingController tripNameController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  CreateTripPage({super.key});

  /// Handles trip creation, validates form and triggers trip creation action.
  Future<bool> _onCreateTripPressed(BuildContext context) async {
    if (formKey.currentState?.validate() ?? false) {
      Navigator.of(context).pop();
      Provider.of<UserProvider>(context, listen: false)
          .addTrip(tripNameController.text);
      return true;
    }
    return false;
  }

  /// Image picker widget
  Widget _buildImagePicker({VoidCallback func = _defaultFunc}) {
    return GestureDetector(
      onTap: func,
      child: Container(
        height: 91.h,
        width: 107.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: const Color(0xFF92A332).withOpacity(0.2),
        ),
        child: Column(
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
      ),
    );
  }

  /// The main content widget that includes the form, image picker, and button.
  Widget _buildFormContent(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 32.0.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20.w),
                  child: _buildImagePicker(),
                ),
                Flexible(
                  child: CustomTextFormField(
                    controller: tripNameController,
                    labelText: "Trip name",
                    hintText: "Enter trip name",
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.only(bottom: 35.0.h),
            child: CustomButton(
              buttonText: "Create Trip",
              onPressed: () => _onCreateTripPressed(context),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      text1: "Create trip",
      text2: "Let the journey begin!",
      childWidget: _buildFormContent(context),
    );
  }
}

void _defaultFunc() {
  debugPrint("Debug from Create Trip Page");
}
