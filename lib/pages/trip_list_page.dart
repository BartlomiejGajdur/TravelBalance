import 'package:TravelBalance/TravelBalanceComponents/no_content_message.dart';
import 'package:TravelBalance/Utils/floating_action_button.dart';
import 'package:TravelBalance/providers/trip_provider.dart';
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
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    _toggleLoading();
    await Provider.of<UserProvider>(context, listen: false)
        .fetchWholeUserData();
    _toggleLoading();
  }

  void _toggleLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  void _navigateToDetails(Trip currentTrip) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (_) => TripProvider(
              currentTrip, Provider.of<UserProvider>(context, listen: false)),
          child: ExpenseListPage(trip: currentTrip),
        ),
      ),
    );
  }

  void _navigateToAddTripPage() {
    Navigator.pushNamed(context, "CreateListPage");
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
          _buildHeader(),
          _buildSubHeader(),
          SizedBox(height: 19.h),
          _buildTripListContainer(),
        ],
      ),
      floatingActionButton:
          buildFloatingActionButton(context, _navigateToAddTripPage),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 53.h,
      child: Row(
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
    );
  }

  Widget _buildSubHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.0.w),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "Your journeys, just a tap away.",
          style: secondaryHeaderTextStyle,
        ),
      ),
    );
  }

  Widget _buildTripListContainer() {
    return Expanded(
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
      return _buildRefreshableTripList(userProvider);
    }
  }

  Widget _buildRefreshableTripList(UserProvider userProvider) {
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
            indexInList: index,
            moveToDetails: () => _navigateToDetails(currentTrip),
          );
        },
      ),
    );
  }
}
