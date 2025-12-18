import 'package:gauva_driver/core/utils/localize.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../data/models/intercity/booking_model.dart';
import '../../../data/repositories/intercity_repo_impl.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({Key? key}) : super(key: key);

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  final IntercityRepositoryImpl _repository = IntercityRepositoryImpl(client: http.Client());
  List<BookingModel> _bookings = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    try {
      final bookings = await _repository.getPendingBookings();
      if (!mounted) return;
      setState(() {
        _bookings = bookings;
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

  Future<void> _acceptBooking(int bookingId) async {
    try {
      await _repository.acceptBooking(bookingId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(localize(context).intercityMsgBookingAccepted)));
      _fetchBookings();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(localize(context).intercityError(e.toString()))));
    }
  }

  Future<void> _rejectBooking(int bookingId) async {
    try {
      // For simplicity, hardcoding reason for now. Could show a dialog to input reason.
      await _repository.rejectBooking(bookingId, "Driver rejected");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(localize(context).intercityMsgBookingRejected)));
      _fetchBookings();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(localize(context).intercityError(e.toString()))));
    }
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
            ElevatedButton(onPressed: _fetchBookings, child: Text(localize(context).intercityActionRetry)),
          ],
        ),
      );
    }

    if (_bookings.isEmpty) {
      return Center(child: Text(localize(context).intercityNoPendingBookings));
    }

    return RefreshIndicator(
      onRefresh: _fetchBookings,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _bookings.length,
        itemBuilder: (context, index) {
          final booking = _bookings[index];
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '#${booking.bookingCode ?? booking.bookingId}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          localize(context).intercityStatusPending,
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),

                  // Passenger Info
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey[200],
                        radius: 20,
                        child: const Icon(Icons.person, color: Colors.grey),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking.passengerName ?? localize(context).intercityUnknownPassenger,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          if (booking.passengerPhone != null)
                            Text(booking.passengerPhone!, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Route
                  Row(
                    children: [
                      const Icon(Icons.circle, size: 10, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(child: Text(booking.pickupAddress ?? '', style: const TextStyle(fontSize: 14))),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 4),
                    height: 15,
                    decoration: const BoxDecoration(
                      border: Border(
                        left: BorderSide(color: Colors.grey, style: BorderStyle.solid, width: 1),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.circle, size: 10, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(child: Text(booking.dropAddress ?? '', style: const TextStyle(fontSize: 14))),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Details
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              localize(context).intercityLabelSeats,
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                            Text(
                              '${booking.seatsBooked}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              localize(context).intercityLabelAmount,
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                            Text(
                              '₹${booking.totalAmount}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.green),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              localize(context).intercityLabelPayment,
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                            Text(
                              booking.paymentMethod ?? localize(context).intercityPaymentCash,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _rejectBooking(booking.bookingId!),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.red),
                            foregroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Text(localize(context).intercityActionReject),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _acceptBooking(booking.bookingId!),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Text(localize(context).intercityActionAccept),
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
}
