import 'package:TravelBalance/TravelBalanceComponents/no_content_message.dart';
import 'package:TravelBalance/Utils/floating_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:TravelBalance/Utils/globals.dart';
import 'package:TravelBalance/components/trip_component.dart';
import 'package:TravelBalance/models/trip.dart';
import 'package:TravelBalance/pages/expense_list_page.dart';
import 'package:TravelBalance/providers/user_provider.dart';
import 'package:TravelBalance/TravelBalanceComponents/app_drawer.dart';

class TripListPage extends StatefulWidget {
  const TripListPage({super.key});

  @override
  _TripListPageState createState() => _TripListPageState();
}

class _TripListPageState extends State<TripListPage> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    toggleLoading();
    await Provider.of<UserProvider>(context, listen: false)
        .fetchWholeUserData();
    toggleLoading();
  }

  void toggleLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  void moveToDetails(Trip currentTrip) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExpenseListPage(trip: currentTrip),
      ),
    );
  }

  void addTrip() {
    Provider.of<UserProvider>(context, listen: false).addTrip();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const AppDrawer(),
      backgroundColor: secondaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 53.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.0.w),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "My Trips",
                    style: mainHeaderTextStyle,
                  ),
                ),
              ),
              Builder(builder: (context) {
                return IconButton(
                  iconSize: 26.sp,
                  icon: const Icon(Icons.menu),
                  color: Colors.white,
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                );
              }),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.0.w),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Your journeys, just a tap away.",
                style: secondaryHeaderTextStyle,
              ),
            ),
          ),
          SizedBox(height: 19.h),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(21.r),
                  topRight: Radius.circular(21.r),
                ),
              ),
              child: Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  return _buildTripList(userProvider);
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: buildFloatingActionButton(context, addTrip),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildTripList(UserProvider userProvider) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: secondaryColor,
        ),
      );
    } else if (userProvider.user == null || userProvider.user!.trips.isEmpty) {
      return noContentMessage(ContentType.Trips);
    } else {
      return RefreshIndicator(
        color: primaryColor,
        onRefresh: () async {
          await userProvider.fetchWholeUserData();
        },
        child: ListView.builder(
          itemCount: userProvider.user!.trips.length,
          itemBuilder: (context, index) {
            final currentTrip = userProvider.user!.trips[index];
            return TripComponent(
              trip: currentTrip,
              moveToDetails: () => moveToDetails(currentTrip),
              deleteFunction: (context) {
                Provider.of<UserProvider>(context, listen: false)
                    .deleteTrip(index);
              },
            );
          },
        ),
      );
    }
  }
}
