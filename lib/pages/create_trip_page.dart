import 'package:TravelBalance/TravelBalanceComponents/custom_button.dart';
import 'package:TravelBalance/TravelBalanceComponents/custom_text_form_field.dart';
import 'package:TravelBalance/Utils/custom_scaffold.dart';
import 'package:TravelBalance/Utils/custom_snack_bar.dart';
import 'package:TravelBalance/Utils/image_picker.dart';
import 'package:TravelBalance/providers/user_provider.dart';
import 'package:TravelBalance/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class CreateTripPage extends StatelessWidget {
  final TextEditingController tripNameController = TextEditingController();
  final TextEditingController placeholder = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final BuildContext mainPageContext;
  CreateTripPage({super.key, required this.mainPageContext});

  String? placeholderValidator(String? string) {
    return null;
  }

  Future<bool> _onCreateTripPressed(BuildContext context) async {
    final String tripName = tripNameController.text;
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Form validation
    if (!(formKey.currentState?.validate() ?? false)) return false;

    // Optimistic update - adding the trip locally
    userProvider.addTrip(tripName);
    Navigator.of(context)
        .pop(); // Immediately close the trip creation screen for better UX

    // Sending the request to the API
    int? tripId = await ApiService().addTrip(tripName);

    if (tripId != null) {
      // If the API returned a valid result, set the trip ID
      userProvider.setTripIdOfLastAddedTrip(tripId);
      return true;
    } else {
      // If the API did not return a valid result, roll back the trip addition
      userProvider.deleteTrip(0); // Remove the last added trip
      showCustomSnackBar(
          context: mainPageContext,
          message:
              "Failed to create $tripName. Please check your Internet connection.",
          type: SnackBarType.error);
      return false;
    }
  }

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
                  child: imagePicker(),
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
          SizedBox(
            height: 30.h,
          ),
          CustomTextFormField(
            controller: placeholder,
            labelText: "Country",
            hintText: "Enter country",
            validator: placeholderValidator,
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.only(bottom: 35.0.h),
            child: CustomButton(
              buttonText: "Create Trip",
              skipWaitingForSucces: true,
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
