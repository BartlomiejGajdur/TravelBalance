import 'package:TravelBalance/TravelBalanceComponents/choose_category.dart';
import 'package:TravelBalance/TravelBalanceComponents/custom_button.dart';
import 'package:TravelBalance/TravelBalanceComponents/custom_text_field.dart';
import 'package:TravelBalance/Utils/custom_scaffold.dart';
import 'package:TravelBalance/Utils/custom_snack_bar.dart';
import 'package:TravelBalance/Utils/date_picker.dart';
import 'package:TravelBalance/models/expense.dart';
import 'package:TravelBalance/providers/trip_provider.dart';
import 'package:TravelBalance/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateExpensePage extends StatelessWidget {
  final TextEditingController expenseDescController = TextEditingController();
  final TextEditingController costController = TextEditingController();
  final TextEditingController dateController =
      TextEditingController(text: formattedDateTimeInString(DateTime.now()));
  final TextEditingController categoryController = TextEditingController();

  final BuildContext expenseListPageContext;
  final TripProvider tripProvider;
  CreateExpensePage(
      {super.key,
      required this.expenseListPageContext,
      required this.tripProvider});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        text1: "Add expense",
        text2: "Where'd that money go?",
        childWidget: _buildContent(context));
  }

  Future<bool> _onCreateExpense(BuildContext context) async {
    String title = expenseDescController.text;
    double cost = double.tryParse(costController.text) ?? 0.0;
    DateTime dateTime = formattedStringInDateTime(dateController.text);
    Category category = Expense.stringToCategory(categoryController.text);

    Expense newExpense = Expense(
      tripId: tripProvider.trip.getId()!,
      title: title,
      cost: cost,
      category: category,
      dateTime: dateTime,
    );

    newExpense.printDetails();

    tripProvider.addExpense(newExpense);
    Navigator.of(context).pop();

    // Sending the request to the API
    int? expenseId = await ApiService().addExpense(newExpense);

    if (expenseId != null) {
      // If the API returned a valid result, set the trip ID
      tripProvider.setExpenseIdOfLastAddedExpense(expenseId);
      return true;
    } else {
      // If the API did not return a valid result, roll back the trip addition
      tripProvider.deleteLastAddedExpense();
      showCustomSnackBar(
          context: expenseListPageContext,
          message:
              "Failed to create Expense. Please check your Internet connection.",
          type: SnackBarType.error);
      return false;
    }
  }

  Column _buildContent(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 47.h),
        CustomTextField(controller: expenseDescController, text: ""),
        SizedBox(height: 24.h),
        CustomTextField(
          controller: costController,
          text: "",
          numbersOnly: true,
          suffixIcon: Icons.monetization_on_outlined,
        ),
        SizedBox(height: 24.h),
        CustomTextField(
          controller: dateController,
          clickAction: ClickAction.Date,
          suffixIcon: Icons.calendar_month,
        ),
        SizedBox(height: 47.h),
        ChooseCategory(
            initialCategoryName:
                Expense.staticCategoryToString(Category.others),
            textController: categoryController),
        Spacer(),
        CustomButton(
            buttonText: "Add expense",
            skipWaitingForSucces: true,
            onPressed: () => _onCreateExpense(context)),
        SizedBox(
          height: 35.h,
        )
      ],
    );
  }
}
