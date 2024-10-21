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
    final String title = expenseDescController.text;
    final double cost = double.tryParse(costController.text) ?? 0.0;
    final DateTime dateTime = getDateTimeWithCurrentTime(dateController.text);
    final Category category = Expense.stringToCategory(categoryController.text);
    final int tripId = tripProvider.trip.getId()!;

    tripProvider.addExpense(tripId, title, cost, category, dateTime);
    Navigator.of(context).pop();

    int? expenseId =
        await ApiService().addExpense(tripId, title, cost, category, dateTime);

    if (expenseId != null) {
      tripProvider.setExpenseIdOfLastAddedExpense(expenseId);
      return true;
    } else {
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
        CustomTextField(
          controller: expenseDescController,
          text: "",
          hintText: "Description",
        ),
        SizedBox(height: 24.h),
        CustomTextField(
          controller: costController,
          text: "",
          numbersOnly: true,
          suffixIcon: Icons.monetization_on_outlined,
          hintText: "Cost",
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
        const Spacer(),
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
