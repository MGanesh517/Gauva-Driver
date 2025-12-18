import 'package:gauva_driver/core/utils/localize.dart';
import 'package:flutter/material.dart';
import 'pages/bookings_page.dart';
import 'pages/my_trips_page.dart';
import 'pages/publish_trip_screen.dart';

class IntercityDashboard extends StatefulWidget {
  const IntercityDashboard({Key? key}) : super(key: key);

  @override
  State<IntercityDashboard> createState() => _IntercityDashboardState();
}

class _IntercityDashboardState extends State<IntercityDashboard> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _refreshKey = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      centerTitle: true,
      title: Text(localize(context).intercityDriverTitle),
      bottom: TabBar(
        controller: _tabController,
        tabs: [
          Tab(text: localize(context).intercityMyTrips),
          Tab(text: localize(context).intercityBookings),
        ],
      ),
    ),
    body: TabBarView(
      controller: _tabController,
      children: [
        MyTripsPage(key: ValueKey('trips_$_refreshKey')),
        BookingsPage(key: ValueKey('bookings_$_refreshKey')),
      ],
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () async {
        await Navigator.push(context, MaterialPageRoute(builder: (context) => const PublishTripScreen()));
        if (mounted) {
          setState(() {
            _refreshKey++;
          });
        }
      },
      child: const Icon(Icons.add),
      tooltip: localize(context).intercityPublishTrip,
    ),
  );
}
