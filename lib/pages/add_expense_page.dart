import 'package:TravelBalance/TravelBalanceComponents/choose_category.dart';
import 'package:TravelBalance/TravelBalanceComponents/currency_pick.dart';
import 'package:TravelBalance/TravelBalanceComponents/custom_button.dart';
import 'package:TravelBalance/TravelBalanceComponents/custom_text_field.dart';
import 'package:TravelBalance/Utils/custom_scaffold.dart';
import 'package:TravelBalance/Utils/custom_snack_bar.dart';
import 'package:TravelBalance/Utils/date_picker.dart';
import 'package:TravelBalance/models/expense.dart';
import 'package:TravelBalance/providers/trip_provider.dart';
import 'package:TravelBalance/providers/user_provider.dart';
import 'package:TravelBalance/services/ad_manager_service.dart';
import 'package:TravelBalance/services/api_service.dart';
import 'package:TravelBalance/services/hive_last_used_currency_storage.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class CreateExpensePage extends StatefulWidget {
  final BuildContext expenseListPageContext;
  final TripProvider tripProvider;

  const CreateExpensePage({
    super.key,
    required this.expenseListPageContext,
    required this.tripProvider,
  });

  @override
  _CreateExpensePageState createState() => _CreateExpensePageState();
}

class _CreateExpensePageState extends State<CreateExpensePage> {
  final TextEditingController _expenseDescController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _dateController = TextEditingController(
    text: formattedDateTimeInString(DateTime.now()),
  );
  final TextEditingController _categoryController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Currency _expenseCurrency;
  @override
  void initState() {
    _expenseCurrency = getCurrency();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      text1: "Add expense",
      text2: "Where'd that money go?",
      childWidget: _buildForm(context),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Column(
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 47.h),
              _buildDescriptionField(),
              SizedBox(height: 24.h),
              _buildCostAndCurrencyRow(),
              SizedBox(height: 24.h),
              _buildDateField(),
            ],
          ),
        ),
        SizedBox(height: 47.h),
        _buildCategorySelector(),
        const Spacer(),
        _buildSubmitButton(),
        SizedBox(height: 35.h),
      ],
    );
  }

  String? expenseNameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    if (value.length > 32) {
      return 'This field cannot have more than 32 characters.';
    }

    return null;
  }

  Widget _buildDescriptionField() {
    return CustomTextField(
        controller: _expenseDescController,
        text: "",
        hintText: "Description",
        validator: expenseNameValidator);
  }

  Widget _buildCostAndCurrencyRow() {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            controller: _costController,
            text: "",
            numbersOnly: true,
            hintText: "Cost",
            rightPadding: false,
          ),
        ),
        CurrencyPick(
            currency: _expenseCurrency, onCurrencyChanged: _onCurrencyChanged),
      ],
    );
  }

  Currency getCurrency() {
    final tripId = widget.tripProvider.trip.getId() ?? -1;
    final lastUsedCurrency =
        LastUsedCurrencyStorage().getLastUsedCurrency(tripId);
    final Currency baseCurrency =
        Provider.of<UserProvider>(context, listen: false).user!.baseCurrency;
    return lastUsedCurrency ?? baseCurrency;
  }

  Widget _buildDateField() {
    return CustomTextField(
      controller: _dateController,
      clickAction: ClickAction.Date,
      suffixIcon: Icons.calendar_month,
    );
  }

  Widget _buildCategorySelector() {
    return ChooseCategory(
      initialCategoryName: Expense.staticCategoryToString(Category.others),
      textController: _categoryController,
    );
  }

  Future<bool> _handleCreateExpense() async {
    if (!_formKey.currentState!.validate()) return false;

    final String title = _expenseDescController.text;
    final double cost = double.tryParse(_costController.text) ?? 0.0;
    final DateTime dateTime = getDateTimeWithCurrentTime(_dateController.text);
    final Category category =
        Expense.stringToCategory(_categoryController.text);
    final int tripId = widget.tripProvider.trip.getId()!;

    AdManagerService()
        .manager()
        .onCreateExpense(widget.tripProvider.trip.expenses.length);

    widget.tripProvider
        .addExpense(tripId, title, cost, _expenseCurrency, category, dateTime);
    Navigator.of(context).pop();

    //Send currency to API
    int? expenseId;
    try {
      expenseId = await ApiService().addExpense(
        tripId,
        title,
        cost,
        _expenseCurrency,
        category,
        dateTime,
      );
    } catch (e) {
      expenseId = null;
      showCustomSnackBar(
        context: widget.expenseListPageContext,
        message: e.toString(),
        type: SnackBarType.error,
      );
    }

    if (expenseId != null) {
      widget.tripProvider.setExpenseIdOfLastAddedExpense(expenseId);
      LastUsedCurrencyStorage().setLastUsedCurrency(tripId, _expenseCurrency);
      return true;
    } else {
      widget.tripProvider.deleteLastAddedExpense();
      return false;
    }
  }

  Widget _buildSubmitButton() {
    return CustomButton(
      buttonText: "Add expense",
      skipWaitingForSucces: true,
      onPressed: () => _handleCreateExpense(),
    );
  }

  void _onCurrencyChanged(Currency newCurrency) {
    setState(() {
      _expenseCurrency = newCurrency;
    });
  }

  @override
  void dispose() {
    _expenseDescController.dispose();
    _costController.dispose();
    _dateController.dispose();
    _categoryController.dispose();
    super.dispose();
  }
}
