import 'package:TravelBalance/TravelBalanceComponents/no_content_message.dart';
import 'package:TravelBalance/TravelBalanceComponents/statistics_tile.dart';
import 'package:TravelBalance/Utils/floating_action_button.dart';
import 'package:TravelBalance/TravelBalanceComponents/short_trip_component.dart';
import 'package:TravelBalance/Utils/loading_tent.dart';
import 'package:TravelBalance/models/custom_image.dart';
import 'package:TravelBalance/providers/trip_provider.dart';
import 'package:TravelBalance/services/ad_manager_service.dart';
import 'package:TravelBalance/services/shared_prefs_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:TravelBalance/Utils/globals.dart';
import 'package:TravelBalance/TravelBalanceComponents/extended_trip_component.dart';
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
  late bool isSwitched;

  @override
  void initState() {
    super.initState();
    if (Provider.of<UserProvider>(context, listen: false).user == null) {
      _fetchUserData();
    }
    isSwitched = SharedPrefsStorage()
        .getBool(SharedPrefsStorage().isShortListTripViewKey);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheAllImages(context);
  }

  @override
  void dispose() {
    AdManagerService().manager().disposeBannerAd();
    super.dispose();
  }

  Future<void> _fetchUserData() async {
    _toggleLoading();
    await Provider.of<UserProvider>(context, listen: false)
        .fetchWholeUserData(context);
    _toggleLoading();
  }

  void _toggleLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  void _navigateToDetails(Trip currentTrip, int indexInList) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (_) => TripProvider(
              currentTrip, Provider.of<UserProvider>(context, listen: false)),
          child: ExpenseListPage(
            trip: currentTrip,
            indexInList: indexInList,
          ),
        ),
      ),
    );
  }

  void _navigateToAddTripPage() {
    Navigator.pushNamed(
      context,
      'CreateListPage',
      arguments: context, // Pass the mainPageContext as an argument
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: AppDrawer(),
      backgroundColor: secondaryColor,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 53.h),
              _buildHeader(),
              _buildSubHeader(),
              SizedBox(height: 19.h),
              _buildTripListContainer(),
            ],
          ),
          Positioned(
            bottom: 16.h, // Adjust this to position your FAB
            left: MediaQuery.of(context).size.width / 2 -
                28, // Center it horizontally
            child: buildFloatingActionButton(context, _navigateToAddTripPage),
          ),
        ],
      ),
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
      return Center(child: LoadingTent());
    } else {
      return _buildRefreshableContent(userProvider);
    }
  }

  Widget _buildRefreshableContent(UserProvider userProvider) {
    return RefreshIndicator(
      color: primaryColor,
      onRefresh: () async {
        await userProvider.fetchWholeUserData(context);
      },
      child: _buildContent(userProvider),
    );
  }

  Widget _buildContent(UserProvider userProvider) {
    if (userProvider.user == null) {
      return _buildSomethingWentWrongMessage(userProvider.ErrorText);
    } else if (userProvider.user!.trips.isEmpty) {
      return _buildNoContentMessage();
    } else {
      return _buildTripContent(userProvider);
    }
  }

  Widget _buildSomethingWentWrongMessage(String errorText) {
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 60.0.h),
          child: Column(children: [
            Text(
              "Uh-oh, Tent Trouble! 😕",
              style: GoogleFonts.outfit(
                fontSize: 24.sp,
                fontWeight: FontWeight.w800,
                color: mainTextColor,
              ),
            ),
            Image.asset(
              "lib/assets/broken_tent.jpg",
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              // child: Text(
              //   "Looks like our tent’s gotten a little torn! 🚧 Something went wrong on our adventure. Double-check your connection or try again soon. Even the most epic trips need a little break!\n${errorText}",
              child: Text(
                "${errorText}",
                style: GoogleFonts.outfit(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: secondaryTextColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ]),
        ),
      ],
    );
  }

  Widget _buildNoContentMessage() {
    return ListView(
      padding: const EdgeInsets.all(0),
      children: [
        Center(
          child: noContentMessage(ContentType.Trips),
        ),
      ],
    );
  }

  Widget _buildTripContent(UserProvider userProvider) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10.0.h),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              StatisticsTile(statisticsTileType: StatisticsTileType.totalTrips),
              StatisticsTile(
                  statisticsTileType: StatisticsTileType.countriesVisited),
              StatisticsTile(statisticsTileType: StatisticsTileType.spendings),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Transform.scale(
            scale: 0.8,
            child: Switch(
              value: isSwitched,
              trackOutlineWidth: const WidgetStatePropertyAll(0),
              inactiveThumbColor: primaryColor,
              inactiveTrackColor: secondaryColor.withOpacity(0.5),
              activeColor: primaryColor,
              onChanged: (value) {
                setState(() {
                  isSwitched = value;
                  SharedPrefsStorage().setBool(
                      SharedPrefsStorage().isShortListTripViewKey, value);
                });
              },
            ),
          ),
        ),
        isSwitched
            ? _buildShortTripList(userProvider)
            : _buildExtendedTripList(userProvider),
        AdManagerService().manager().bannerAd(),
      ],
    );
  }

  Widget _buildExtendedTripList(UserProvider userProvider) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(0.0),
        itemCount: userProvider.user!.trips.length,
        itemBuilder: (context, index) {
          final currentTrip = userProvider.user!.trips[index];
          return ExtendedTripComponent(
            trip: currentTrip,
            moveToDetails: () => _navigateToDetails(currentTrip, index),
          );
        },
      ),
    );
  }

  Widget _buildShortTripList(UserProvider userProvider) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(0.0),
        itemCount: userProvider.user!.trips.length,
        itemBuilder: (context, index) {
          final currentTrip = userProvider.user!.trips[index];
          return ShortTripComponent(
            trip: currentTrip,
            moveToDetails: () => _navigateToDetails(currentTrip, index),
          );
        },
      ),
    );
  }
}
