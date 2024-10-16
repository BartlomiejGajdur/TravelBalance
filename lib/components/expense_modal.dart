import 'package:TravelBalance/TravelBalanceComponents/custom_button.dart';
import 'package:TravelBalance/TravelBalanceComponents/custom_text_field.dart';
import 'package:TravelBalance/Utils/date_picker.dart';
import 'package:TravelBalance/Utils/globals.dart';
import 'package:TravelBalance/models/expense.dart';
import 'package:TravelBalance/providers/expense_provider.dart';
import 'package:TravelBalance/providers/trip_provider.dart';
import 'package:TravelBalance/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ModalBottomSheetExpense extends StatefulWidget {
  final ExpenseProvider expenseProvider;
  const ModalBottomSheetExpense({super.key, required this.expenseProvider});

  @override
  State<ModalBottomSheetExpense> createState() =>
      _ModalBottomSheetExpenseState();
}

class _ModalBottomSheetExpenseState extends State<ModalBottomSheetExpense> {
  final TextEditingController descriptionController = TextEditingController();

  final TextEditingController costController = TextEditingController();

  final TextEditingController dateController = TextEditingController();

  final TextEditingController categoryController = TextEditingController();

  @override
  void dispose() {
    descriptionController.dispose();
    costController.dispose();
    dateController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  Future<bool> saveExpense(
      BuildContext context, ExpenseProvider expenseProvider) async {
    String title = descriptionController.text;
    double cost = double.parse(costController.text);
    Category category = Expense.stringToCategory(categoryController.text);
    DateTime dateTime = formattedStringInDateTime(dateController.text);

    ApiService().editExpense(
      expenseProvider.expense.tripId,
      expenseProvider.expense.id,
      title,
      cost,
      category,
      dateTime,
    );

    expenseProvider.editExpense(title, cost, category, dateTime);

    return true;
  }

  Widget formattedTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 12.w, right: 12.w, bottom: 4.h),
      child: Text(
        title,
        style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
            color: const Color(0xFF0D0E0F)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 493.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0.0, 10.h, 10.w, 0.0),
              child: Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  )),
            ),
            formattedTitle("Description"),
            CustomTextField(
                text: widget.expenseProvider.expense.title,
                controller: descriptionController,
                textFieldBottomPadding: 16.0.h),
            formattedTitle("Cost"),
            CustomTextField(
              text: widget.expenseProvider.expense.cost.toString(),
              controller: costController,
              textFieldBottomPadding: 16.0.h,
              suffixIcon: Icons.monetization_on_outlined,
              numbersOnly: true,
            ),
            formattedTitle("Date"),
            CustomTextField(
              text: formattedDateTimeInString(
                  widget.expenseProvider.expense.dateTime),
              controller: dateController,
              textFieldBottomPadding: 16.0.h,
              suffixIcon: Icons.calendar_month_outlined,
              clickAction: ClickAction.Date,
            ),
            formattedTitle("Category"),
            CustomTextField(
              text: widget.expenseProvider.expense.categoryToString(),
              controller: categoryController,
              textFieldBottomPadding: 16.0.h,
              suffixIcon: Icons.category,
              clickAction: ClickAction.Category,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DeleteExpenseIcon(
                  tripProvider: widget.expenseProvider.tripProvider,
                  expenseId: widget.expenseProvider.expense.id,
                ),
                SizedBox(width: 11.w),
                SizedBox(
                    width: 250.w,
                    child: CustomButton(
                      buttonText: "Save Expense",
                      useDefaultPadding: false,
                      skipWaitingForSucces: true,
                      onPressed: () =>
                          saveExpense(context, widget.expenseProvider),
                      onSkippedSuccess: () => Navigator.of(context).pop(),
                    ))
              ],
            ),
          ],
        ));
  }
}

class DeleteExpenseIcon extends StatelessWidget {
  final TripProvider tripProvider;
  final int expenseId;

  const DeleteExpenseIcon({
    super.key,
    required this.tripProvider,
    required this.expenseId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return SizedBox(
              height: 205.h,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                          padding: const EdgeInsets.all(0),
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close_sharp))),
                  Text(
                    'Are you sure you want to delete this expense ?',
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 15.sp,
                        color: const Color(0xFF292B2D)),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          tripProvider.deleteExpense(expenseId);
                          ApiService().deleteExpense(
                              tripProvider.trip.getId(), expenseId);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 327.w,
                          height: 48.h,
                          decoration: BoxDecoration(
                              color: redWarningColor,
                              borderRadius: BorderRadius.circular(999.r)),
                          child: Center(
                              child: Text('Delete expense',
                                  style: GoogleFonts.outfit(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.sp,
                                      color: const Color(0xFFFFFFFF)))),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 327.w,
                          height: 48.h,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 231, 235, 243),
                              borderRadius: BorderRadius.circular(999.r)),
                          child: Center(
                              child: Text('Cancel',
                                  style: GoogleFonts.outfit(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.sp,
                                      color: Colors.black))),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
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
    );
  }
}
