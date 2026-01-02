import 'package:gauva_driver/core/utils/localize.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../../../data/models/intercity/trip_model.dart';
import '../../../data/models/intercity/booking_model.dart';
import '../../../data/repositories/intercity_repo_impl.dart';

import 'package:intl/intl.dart';

class MyTripsPage extends StatefulWidget {
  const MyTripsPage({Key? key}) : super(key: key);

  @override
  State<MyTripsPage> createState() => _MyTripsPageState();
}

class _MyTripsPageState extends State<MyTripsPage> {
  final IntercityRepositoryImpl _repository = IntercityRepositoryImpl(client: http.Client());
  List<TripModel> _trips = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchTrips();
  }

  Future<void> _fetchTrips() async {
    try {
      final trips = await _repository.getMyTrips();
      if (!mounted) return;
      setState(() {
        _trips = trips;
        _isLoading = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _startTrip(int tripId) async {
    try {
      await _repository.startTrip(tripId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(localize(context).intercityTripStarted)));
      _fetchTrips();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(localize(context).intercityError(e.toString()))));
    }
  }

  Future<void> _completeTrip(int tripId) async {
    try {
      await _repository.completeTrip(tripId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(localize(context).intercityTripCompleted)));
      _fetchTrips();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(localize(context).intercityError(e.toString()))));
    }
  }

  Future<void> _viewMap(TripModel trip) async {
    final url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&origin=${Uri.encodeComponent(trip.pickupAddress ?? '')}&destination=${Uri.encodeComponent(trip.dropAddress ?? '')}&travelmode=driving',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(localize(context).intercityMapLaunchError)));
    }
  }

  void _showPassengers(int tripId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) =>
            _PassengerListSheet(tripId: tripId, repository: _repository, scrollController: scrollController),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(localize(context).intercityError(_error!)),
            ElevatedButton(onPressed: _fetchTrips, child: Text(localize(context).intercityActionRetry)),
          ],
        ),
      );
    }

    if (_trips.isEmpty) {
      return Center(child: Text(localize(context).intercityNoPublishedTrips));
    }

    return RefreshIndicator(
      onRefresh: _fetchTrips,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _trips.length,
        itemBuilder: (context, index) {
          final trip = _trips[index];
          final dt = trip.scheduledDeparture?.toLocal();
          final dateStr = dt != null ? DateFormat('dd MMM yyyy').format(dt) : 'N/A';
          final timeStr = dt != null ? DateFormat('hh:mm a').format(dt) : 'N/A';

          return Card(
            color: Colors.white,
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row 1: ID & Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '#${trip.tripCode ?? trip.tripId}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: _getStatusColor(trip.status),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _getStatusText(context, trip.status),
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),

                  // Row 2: Route
                  Row(
                    children: [
                      const Icon(Icons.circle, size: 12, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          trip.pickupAddress ?? '',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 5),
                    height: 20,
                    decoration: const BoxDecoration(
                      border: Border(
                        left: BorderSide(color: Colors.grey, style: BorderStyle.solid),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.circle, size: 12, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          trip.dropAddress ?? '',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Row 3: Date & Time separated
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(dateStr, style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 20),
                      const Icon(Icons.access_time, size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(timeStr, style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Row 4: Vehicle & Seats
                  Row(
                    children: [
                      const Icon(Icons.directions_car, size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(trip.vehicleDisplayName ?? trip.vehicleType ?? localize(context).intercityCar),
                      const Spacer(),
                      const Icon(Icons.airline_seat_recline_normal, size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text('${trip.availableSeats}/${trip.totalSeats} ${localize(context).intercitySeats}'),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Row 5: Actions
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      // View Map Button
                      OutlinedButton.icon(
                        onPressed: () => _viewMap(trip),
                        icon: const Icon(Icons.map, size: 16),
                        label: Text(localize(context).intercityMap),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),

                      // Passengers Button
                      OutlinedButton.icon(
                        onPressed: () => _showPassengers(trip.tripId!),
                        icon: const Icon(Icons.people, size: 16),
                        label: Text(localize(context).intercityPassengers),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),

                      if ((trip.status == 'PUBLISHED' ||
                              trip.status == 'DISPATCHED' ||
                              trip.status == 'FILLING' ||
                              trip.status == 'MIN_REACHED') &&
                          (trip.seatsBooked ?? 0) > 0)
                        ElevatedButton.icon(
                          onPressed: () => _startTrip(trip.tripId!),
                          icon: const Icon(Icons.play_arrow, size: 16),
                          label: Text(localize(context).intercityStartTrip),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),

                      if (trip.status == 'IN_PROGRESS')
                        ElevatedButton.icon(
                          onPressed: () => _completeTrip(trip.tripId!),
                          icon: const Icon(Icons.flag, size: 16),
                          label: Text(localize(context).intercityComplete),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'PUBLISHED':
        return Colors.blue;
      case 'PENDING':
        return Colors.amber; // "yellow like that"
      case 'DISPATCHED':
      case 'MIN_REACHED':
        return Colors.green;
      case 'IN_PROGRESS':
        return Colors.orange;
      case 'COMPLETED':
        return Colors.teal;
      case 'CANCELLED':
        return Colors.red;
      case 'FILLING':
        return Colors.lightBlue;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(BuildContext context, String? status) {
    switch (status) {
      case 'PUBLISHED':
        return localize(context).intercityStatusPublished;
      case 'PENDING':
        return localize(context).intercityStatusPending;
      case 'DISPATCHED':
        return localize(context).intercityStatusDispatched;
      case 'MIN_REACHED':
        return localize(context).intercityStatusMinReached;
      case 'IN_PROGRESS':
        return localize(context).intercityStatusInProgress;
      case 'COMPLETED':
        return localize(context).intercityStatusCompleted;
      case 'CANCELLED':
        return localize(context).intercityStatusCancelled;
      case 'FILLING':
        return localize(context).intercityStatusFilling;
      default:
        return localize(context).intercityStatusUnknown;
    }
  }
}

class _PassengerListSheet extends StatefulWidget {
  final int tripId;
  final IntercityRepositoryImpl repository;
  final ScrollController scrollController;

  const _PassengerListSheet({required this.tripId, required this.repository, required this.scrollController});

  @override
  State<_PassengerListSheet> createState() => _PassengerListSheetState();
}

class _PassengerListSheetState extends State<_PassengerListSheet> {
  List<BookingModel>? _bookings;
  bool _isLoading = true;
  String? _error;
  int _totalOnboarded = 0;
  int _totalVerified = 0;

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    try {
      final bookings = await widget.repository.getTripBookings(widget.tripId);
      if (!mounted) return;
      int totalOnboarded = 0;
      int totalVerified = 0;
      for (var b in bookings) {
        totalOnboarded += (b.passengersOnboarded ?? 0);
        if (b.otpVerified == true) totalVerified++;
      }
      setState(() {
        _bookings = bookings;
        _totalOnboarded = totalOnboarded;
        _totalVerified = totalVerified;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _verifyOtp(int bookingId, String otp) async {
    try {
      await widget.repository.verifyOtp(bookingId, int.parse(otp));
      if (!mounted) return;
      Navigator.pop(context); // Close dialog
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(localize(context).intercityOtpVerifiedSuccess)));
      _fetchBookings(); // Refresh list
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Close dialog
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(localize(context).intercityVerificationFailed(e.toString()))));
    }
  }

  void _showOtpDialog(int bookingId) {
    final otpController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localize(context).intercityEnterOtpDialog),
        content: TextField(
          controller: otpController,
          decoration: InputDecoration(labelText: localize(context).intercityOtpHint),
          keyboardType: TextInputType.number,
          maxLength: 6,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(localize(context).intercityCancel)),
          ElevatedButton(
            onPressed: () {
              if (otpController.text.length == 6) {
                _verifyOtp(bookingId, otpController.text);
              }
            },
            child: Text(localize(context).intercityVerify),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
          ),
          Text(localize(context).intercityPassengers, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                ? Center(child: Text(localize(context).intercityError(_error!)))
                : _bookings == null || _bookings!.isEmpty
                ? Center(child: Text(localize(context).intercityNoBookings))
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatCard(
                              localize(context).intercityVerified,
                              '$_totalVerified/${_bookings!.length}',
                              Colors.green,
                            ),
                            _buildStatCard(localize(context).intercityOnboarded, '$_totalOnboarded', Colors.blue),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          controller: widget.scrollController,
                          itemCount: _bookings!.length,
                          itemBuilder: (context, index) {
                            final booking = _bookings![index];
                            final isVerified = booking.otpVerified ?? false;
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: isVerified ? Colors.green[100] : Colors.orange[100],
                                  child: Icon(
                                    isVerified ? Icons.check : Icons.person,
                                    color: isVerified ? Colors.green : Colors.orange,
                                  ),
                                ),
                                title: Text(booking.passengerName ?? localize(context).intercityUnknownPassenger),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${booking.seatsBooked} Seats • ${booking.status}'),
                                    if (booking.passengersOnboarded != null && booking.passengersOnboarded! > 0)
                                      Text(
                                        '${localize(context).intercityOnboardedLabel}${booking.passengersOnboarded}',
                                        style: const TextStyle(fontSize: 12, color: Colors.green),
                                      ),
                                  ],
                                ),
                                isThreeLine: true,
                                trailing: isVerified
                                    ? const Icon(Icons.check_circle, color: Colors.green)
                                    : ElevatedButton(
                                        onPressed: () => _showOtpDialog(booking.bookingId!),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          minimumSize: Size.zero,
                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        child: Text(
                                          localize(context).intercityVerifyOtp,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: color),
          ),
          Text(label, style: TextStyle(fontSize: 12, color: color)),
        ],
      ),
    );
  }
}
