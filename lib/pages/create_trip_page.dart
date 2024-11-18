import 'package:TravelBalance/TravelBalanceComponents/custom_button.dart';
import 'package:TravelBalance/TravelBalanceComponents/custom_text_form_field.dart';
import 'package:TravelBalance/Utils/country_picker.dart';
import 'package:TravelBalance/Utils/custom_scaffold.dart';
import 'package:TravelBalance/Utils/custom_snack_bar.dart';
import 'package:TravelBalance/Utils/image_picker.dart';
import 'package:TravelBalance/models/custom_image.dart';
import 'package:TravelBalance/providers/user_provider.dart';
import 'package:TravelBalance/services/ad_manager_service.dart';
import 'package:TravelBalance/services/api_service.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class CreateTripPage extends StatefulWidget {
  final BuildContext mainPageContext;

  const CreateTripPage({super.key, required this.mainPageContext});

  @override
  _CreateTripPageState createState() => _CreateTripPageState();
}

class _CreateTripPageState extends State<CreateTripPage> {
  final TextEditingController tripNameController = TextEditingController();
  final TextEditingController placeholder = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  CustomImage imagePicked = CustomImage.defaultLandscape;
  List<Country> countries = [];

  @override
  void dispose() {
    tripNameController.dispose();
    placeholder.dispose();
    super.dispose();
  }

  @override
  void initState() {
    AdManagerService().loadInterstitialAd(context);
    super.initState();
  }

  String? placeholderValidator(String? string) {
    return null;
  }

  Future<bool> _onCreateTripPressed(BuildContext context) async {
    final String tripName = tripNameController.text;
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (!(formKey.currentState?.validate() ?? false)) return false;

    AdManagerService().adOnCreateTrip(context,userProvider.user!.trips.length);
    userProvider.addTrip(tripName, imagePicked, countries);
    Navigator.of(context).pop();

    int? tripId = await ApiService().addTrip(tripName, imagePicked, countries);

    if (tripId != null) {
      userProvider.setTripIdOfLastAddedTrip(tripId);
      return true;
    } else {
      userProvider.deleteLastAddedTrip();
      showCustomSnackBar(
          context: widget.mainPageContext,
          message:
              "Failed to create $tripName. Please check your Internet connection.",
          type: SnackBarType.error);
      return false;
    }
  }

  void _updatePickedImage(CustomImage newImage) {
    setState(() {
      imagePicked = newImage;
    });
  }

  void _onCountriesChanged(List<Country> countriesChange) {
    countries = countriesChange;
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
                  child: imagePicker(context, imagePicked, _updatePickedImage),
                ),
                Flexible(
                  child: CustomTextFormField(
                    controller: tripNameController,
                    labelText: "Trip name",
                    hintText: "Enter trip name",
                    validator: tripNameValidator,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          CountryPicker(onCountriesChanged: _onCountriesChanged),
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
