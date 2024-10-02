import 'package:TravelBalance/TravelBalanceComponents/custom_button.dart';
import 'package:TravelBalance/TravelBalanceComponents/custom_text_form_field.dart';
import 'package:TravelBalance/Utils/custom_scaffold.dart';
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

  CreateTripPage({super.key});

  String? placeholderValidator(String? string) {
    return null;
  }

  /// Handles trip creation, validates form and triggers trip creation action.
  Future<bool> _onCreateTripPressed(BuildContext context) async {
    String tripName = tripNameController.text;
    if (formKey.currentState?.validate() ?? false) {
      int? result = await ApiService().addTrip(tripName);

      if (result != null) {
        Provider.of<UserProvider>(context, listen: false)
            .addTrip(result, tripName);
        return true;
      }
    }
    return false;
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
              onPressed: () => _onCreateTripPressed(context),
              onSuccess: () => Navigator.of(context).pop(),
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
