import 'package:TravelBalance/TravelBalanceComponents/custom_text_form_field.dart';
import 'package:TravelBalance/Utils/country_picker.dart';
import 'package:TravelBalance/Utils/delete_dialog.dart';
import 'package:TravelBalance/Utils/globals.dart';
import 'package:TravelBalance/Utils/image_picker.dart';
import 'package:TravelBalance/models/custom_image.dart';
import 'package:TravelBalance/providers/trip_provider.dart';
import 'package:TravelBalance/services/api_service.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditTrip extends StatefulWidget {
  final TripProvider tripProvider;
  final int indexInList;

  const EditTrip(
      {super.key, required this.tripProvider, required this.indexInList});

  @override
  _EditTripState createState() => _EditTripState();
}

class _EditTripState extends State<EditTrip> {
  final TextEditingController tripNameController = TextEditingController();
  final TextEditingController placeholderController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late CustomImage imagePicked;
  List<Country> countries = [];
  @override
  void initState() {
    super.initState();
    imagePicked = widget.tripProvider.trip.customImage;
    tripNameController.text = widget.tripProvider.trip.name;
    countries = widget.tripProvider.trip.countries;
  }

  @override
  void dispose() {
    tripNameController.dispose();
    placeholderController.dispose();
    super.dispose();
  }

  String? placeholderValidator(String? string) {
    return null;
  }

  void _onCountriesChanged(List<Country> countriesChange) {
    countries = countriesChange;
  }

  void _editTrip(BuildContext context, TripProvider tripProvider,
      String newName, List<Country> countries) {
    int? tripId = tripProvider.trip.getId();
    if (tripId != null) {
      ApiService().editTrip(tripId, newName, imagePicked, countries);
      tripProvider.editTrip(newName, imagePicked, countries);
    }
    Navigator.of(context).pop();
  }

  void _updatePickedImage(CustomImage newImage) {
    setState(() {
      imagePicked = newImage;
    });
  }

  Widget _buildFormContent(BuildContext context) {
    return SizedBox(
      height: 500.h,
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0.h, 10.w, 0),
              child: Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: Navigator.of(context).pop,
                  )),
            ),
            Row(
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
            SizedBox(height: 20.h),
            CountryPicker(
              countries: widget.tripProvider.trip.countries,
              onCountriesChanged: _onCountriesChanged,
              listHeight: 150.h,
            ),
            SizedBox(height: 12.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 28.w),
              child: Divider(
                thickness: 1.w,
                color: Colors.grey[300],
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    showDeleteTripDialog(context, widget.tripProvider.trip, true);
                  },
                  child: Container(
                    height: 56.h,
                    width: 67.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      color: redWarningColor.withOpacity(0.2),
                    ),
                    child: Icon(
                      Icons.delete_forever_sharp,
                      size: 40.h,
                      color: redWarningColor,
                    ),
                  ),
                ),
                SizedBox(width: 11.w),
                GestureDetector(
                  onTap: () => _editTrip(context, widget.tripProvider,
                      tripNameController.text, countries),
                  child: Container(
                    height: 56.h,
                    width: 273.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      color: primaryColor,
                    ),
                    child: Text("Save Trip", style: buttonTextStyle),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildFormContent(context);
  }
}
