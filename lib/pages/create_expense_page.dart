import 'package:TravelBalance/Utils/custom_scaffold.dart';
import 'package:TravelBalance/providers/trip_provider.dart';
import 'package:flutter/material.dart';

class CreateExpensePage extends StatelessWidget {
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
        childWidget: Column(
          children: [],
        ));
  }
}
