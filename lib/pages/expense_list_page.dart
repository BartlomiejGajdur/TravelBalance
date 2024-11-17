import 'package:TravelBalance/TravelBalanceComponents/edit_trip.dart';
import 'package:TravelBalance/TravelBalanceComponents/expense_chart.dart';
import 'package:TravelBalance/TravelBalanceComponents/no_content_message.dart';
import 'package:TravelBalance/Utils/custom_scaffold.dart';
import 'package:TravelBalance/TravelBalanceComponents/expense_sheet_component.dart';
import 'package:TravelBalance/providers/trip_provider.dart';
import 'package:flutter/material.dart';
import 'package:TravelBalance/models/trip.dart';
import 'package:provider/provider.dart';

class ExpenseListPage extends StatelessWidget {
  final Trip trip;
  final int indexInList;

  Widget _expenseListPageContent(BuildContext context) {
    return Consumer<TripProvider>(
      builder: (context, tripProvider, child) {
        return Column(
          children: [
            ExpenseChart(
              tripProvider: tripProvider,
            ),
            Expanded(
              child: ListView.builder(
                key: ValueKey(tripProvider.trip.groupExpensesByDate()),
                padding: const EdgeInsets.all(0),
                itemCount: tripProvider.trip.groupExpensesByDate().length,
                itemBuilder: (context, index) {
                  DateTime date = tripProvider.trip
                      .groupExpensesByDate()
                      .keys
                      .toList()[index];
                  return ExpenseSheetComponent(dateTime: date);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _navigateToAddExpensePage(
      BuildContext expenseListPageContext, TripProvider tripProvider) {
    Navigator.pushNamed(
      expenseListPageContext,
      'CreateExpensePage',
      arguments: {
        'expenseListPageContext': expenseListPageContext,
        'tripProvider': tripProvider,
      },
    );
  }

  const ExpenseListPage(
      {super.key, required this.trip, required this.indexInList});

  @override
  Widget build(BuildContext context) {
    final tripProvider = Provider.of<TripProvider>(context);
    return CustomScaffold(
        text1: trip.name,
        text2: "Discover your travel costs.",
        onActionButtonClick: () =>
            _navigateToAddExpensePage(context, tripProvider),
        onEditIconClick: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: EditTrip(
                  tripProvider: tripProvider,
                  indexInList: indexInList,
                ),
              );
            },
          );
        },
        childWidget: tripProvider.isExpenseListEmpty()
            ? noContentMessage(ContentType.Expenses)
            : _expenseListPageContent(context));
  }
}
