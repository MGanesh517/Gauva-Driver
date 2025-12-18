import 'package:gauva_driver/core/utils/localize.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:math' show cos, sqrt, asin;
import '../../../data/repositories/intercity_repo_impl.dart';
import '../../../data/models/intercity/intercity_route_model.dart';
import '../../../data/services/google_places_service.dart';
import '../../../../generated/l10n.dart';

class PublishTripScreen extends StatefulWidget {
  const PublishTripScreen({Key? key}) : super(key: key);

  @override
  State<PublishTripScreen> createState() => _PublishTripScreenState();
}

class _PublishTripScreenState extends State<PublishTripScreen> {
  final _formKey = GlobalKey<FormState>();
  final IntercityRepositoryImpl _repository = IntercityRepositoryImpl(client: http.Client());
  final GooglePlacesService _placesService = GooglePlacesService();

  // Controllers
  final TextEditingController _fromController = TextEditingController(); // New From Controller
  final TextEditingController _toController = TextEditingController(); // New To Controller

  final TextEditingController _pickupLocationController = TextEditingController();
  final TextEditingController _dropLocationController = TextEditingController();

  final TextEditingController _pickupFullAddressController = TextEditingController();
  final TextEditingController _dropFullAddressController = TextEditingController();

  final TextEditingController _pickupLatController = TextEditingController();
  final TextEditingController _pickupLngController = TextEditingController();
  final TextEditingController _dropLatController = TextEditingController();
  final TextEditingController _dropLngController = TextEditingController();

  final TextEditingController _seatsController = TextEditingController(text: '4');
  final TextEditingController _fareController = TextEditingController();
  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _nightFareMultiplierController = TextEditingController(text: '1.2');

  // State Variables
  List<IntercityRouteModel> _availableRoutes = [];
  List<String> _serviceTypes = ['CAR_NORMAL', 'CAR_PREMIUM_EXPRESS', 'AUTO_NORMAL', 'TATA_MAGIC_LITE'];

  // We keep these to attempt route matching, but they are no longer directly driven by dropdowns
  int? _selectedRouteId;

  // Keys to force rebuild of Autocomplete widgets when pre-filled
  Key _pickupInputKey = UniqueKey();
  Key _dropInputKey = UniqueKey();
  Key _fromInputKey = UniqueKey();
  Key _toInputKey = UniqueKey();

  String _selectedBookingType = 'SHARE_POOL';
  String? _selectedVehicleType;

  DateTime? _scheduledDeparture;
  bool _isReturnTrip = false;
  DateTime? _returnTripDeparture;
  bool _isNightFareEnabled = false;
  bool _isPremiumNotification = false;
  bool _isLoading = true;
  bool _isSubmitting = false;

  final List<String> _bookingTypes = ['SHARE_POOL', 'PRIVATE'];

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    if (_serviceTypes.isNotEmpty) {
      _selectedVehicleType = _serviceTypes.first;
    }
    _fetchInitialData();

    // Add listeners for auto-calculation
    _pickupLatController.addListener(_calculateDistance);
    _pickupLngController.addListener(_calculateDistance);
    _dropLatController.addListener(_calculateDistance);
    _dropLngController.addListener(_calculateDistance);
  }

  @override
  void dispose() {
    _pickupLatController.dispose();
    _pickupLngController.dispose();
    _dropLatController.dispose();
    _dropLngController.dispose();
    _pickupLocationController.dispose();
    _dropLocationController.dispose();
    _fromController.dispose();
    _toController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _fetchInitialData() async {
    try {
      final routes = await _repository.getRoutes();
      final types = await _repository.getServiceTypes();

      if (mounted) {
        setState(() {
          _availableRoutes = routes;
          if (types.isNotEmpty) {
            _serviceTypes = types;
            _selectedVehicleType = _serviceTypes.first;
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        // Fallback already set, so just log
        print('Error loading data: $e');
      }
    }
  }

  void _calculateDistance() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final pLat = double.tryParse(_pickupLatController.text);
      final pLng = double.tryParse(_pickupLngController.text);
      final dLat = double.tryParse(_dropLatController.text);
      final dLng = double.tryParse(_dropLngController.text);

      if (pLat != null && pLng != null && dLat != null && dLng != null) {
        const p = 0.017453292519943295; // Math.PI / 180
        final a = 0.5 - cos((dLat - pLat) * p) / 2 + cos(pLat * p) * cos(dLat * p) * (1 - cos((dLng - pLng) * p)) / 2;
        final distance = 12742 * asin(sqrt(a)); // 2 * R * asin...

        setState(() {
          _distanceController.text = distance.toStringAsFixed(2);
        });
      }
    });
  }

  // Attempt to identify route ID based on loose matching of text
  // This is a "nice to have" since we removed strict dropdowns
  void _attemptRouteMatch() {
    final from = _fromController.text.toLowerCase();
    final to = _toController.text.toLowerCase();

    if (from.isEmpty || to.isEmpty) {
      _selectedRouteId = null;
      return;
    }

    try {
      final route = _availableRoutes.firstWhere((r) {
        final rFrom = (r.originName ?? '').toLowerCase();
        final rTo = (r.destinationName ?? '').toLowerCase();
        // Check if selected location contains the route city name or vice versa
        return (from.contains(rFrom) || rFrom.contains(from)) && (to.contains(rTo) || rTo.contains(to));
      });
      _selectedRouteId = route.id;
      print("Matched Route ID: $_selectedRouteId");
    } catch (e) {
      _selectedRouteId = null;
    }
  }

  Future<void> _pickDateTime({required bool isReturn}) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
    );
    if (date != null) {
      final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
      if (time != null) {
        setState(() {
          final result = DateTime(date.year, date.month, date.day, time.hour, time.minute);
          if (isReturn) {
            _returnTripDeparture = result;
          } else {
            _scheduledDeparture = result;
          }
        });
      }
    }
  }

  Future<void> _publishTrip() async {
    if (!_formKey.currentState!.validate()) return;
    if (_scheduledDeparture == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).intercitySelectDepartureTimeError)));
      return;
    }

    setState(() => _isSubmitting = true);

    // Final check for route match before publishing
    _attemptRouteMatch();

    try {
      final tripData = {
        'bookingType': _selectedBookingType,
        'vehicleType': _selectedVehicleType,
        'routeId': _selectedRouteId,
        'pickupAddress': _pickupLocationController.text.isNotEmpty
            ? _pickupLocationController.text
            : _pickupFullAddressController.text, // Fallback
        'dropAddress': _dropLocationController.text.isNotEmpty
            ? _dropLocationController.text
            : _dropFullAddressController.text, // Fallback
        'pickupLatitude': double.tryParse(_pickupLatController.text) ?? 0.0,
        'pickupLongitude': double.tryParse(_pickupLngController.text) ?? 0.0,
        'dropLatitude': double.tryParse(_dropLatController.text) ?? 0.0,
        'dropLongitude': double.tryParse(_dropLngController.text) ?? 0.0,
        'seats': int.parse(_seatsController.text),
        'totalFare': double.tryParse(_fareController.text) ?? 0.0,
        'estimatedDistance': double.tryParse(_distanceController.text) ?? 0.0,
        'distanceKm': double.tryParse(_distanceController.text) ?? 0.0,
        'scheduledDeparture': _scheduledDeparture!.toIso8601String(),
        'returnTrip': _isReturnTrip,
        'returnDate': _returnTripDeparture?.toIso8601String(),
        'nightFareEnabled': _isNightFareEnabled,
        'nightFareMultiplier': _isNightFareEnabled
            ? (double.tryParse(_nightFareMultiplierController.text) ?? 1.2)
            : null,
        'premiumNotification': _isPremiumNotification,
      };

      await _repository.publishTrip(tripData);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).intercityTripPublishedSuccess)));
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).intercityError(e.toString()))));
        setState(() => _isSubmitting = false);
      }
    }
  }

  // --- Google Maps Autocomplete Helper ---
  Widget _buildLocationAutocomplete({
    required Key key, // Added key parameter
    required String label,
    required TextEditingController controller,
    // Optional coord controllers (From/To might not need them displayed, but useful for prefilling)
    TextEditingController? latController,
    TextEditingController? lngController,
    TextEditingController? addressController,
    Function(Map<String, dynamic>)? onItemSelected, // Hook for extra logic
  }) => LayoutBuilder(
    builder: (context, constraints) => Autocomplete<Map<String, dynamic>>(
      key: key, // Use the key
      initialValue: TextEditingValue(text: controller.text),
      optionsBuilder: (TextEditingValue textEditingValue) async {
        if (textEditingValue.text.length < 3) {
          return const Iterable<Map<String, dynamic>>.empty();
        }
        return await _placesService.getPlacePredictions(textEditingValue.text);
      },
      displayStringForOption: (Map<String, dynamic> option) => option['description'] ?? '',
      onSelected: (Map<String, dynamic> selection) async {
        // 1. Update text controller immediately with selection text to avoid flicker
        controller.text = selection['description'] ?? '';

        // 2. Fetch details
        final details = await _placesService.getPlaceDetails(selection['place_id']);
        if (details != null) {
          final fullAddress = details['address'] ?? selection['description'];
          controller.text = fullAddress; // Update with full address

          if (latController != null) latController.text = details['lat'].toString();
          if (lngController != null) lngController.text = details['lng'].toString();
          if (addressController != null) addressController.text = fullAddress;

          if (onItemSelected != null) {
            onItemSelected(details);
          }

          _calculateDistance(); // Trigger calculation
        }
      },
      fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
        // Keep the internal controller in sync if needed
        if (controller.text.isNotEmpty && textEditingController.text.isEmpty) {
          textEditingController.text = controller.text;
        }

        return TextFormField(
          controller: textEditingController,
          focusNode: focusNode,
          decoration: _inputDecoration(label).copyWith(suffixIcon: const Icon(Icons.search, color: Colors.grey)),
          validator: (v) => v?.isEmpty ?? true ? AppLocalizations.of(context).intercityRequiredError : null,
          onChanged: (val) {
            controller.text = val;
          },
        );
      },
      optionsViewBuilder: (context, onSelected, options) => Align(
        alignment: Alignment.topLeft,
        child: Material(
          elevation: 4.0,
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          child: Container(
            width: constraints.maxWidth,
            constraints: const BoxConstraints(maxHeight: 250),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: options.length,
              itemBuilder: (BuildContext context, int index) {
                final option = options.elementAt(index);
                return ListTile(
                  leading: const Icon(Icons.location_on_outlined, color: Colors.grey, size: 20),
                  title: Text(option['main_text'] ?? '', style: const TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: Text(
                    option['secondary_text'] ?? '',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  onTap: () => onSelected(option),
                );
              },
            ),
          ),
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      centerTitle: true,
      title: Text(AppLocalizations.of(context).intercityCreateNewTrip),
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
    ),
    bottomNavigationBar: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _isSubmitting ? null : _publishTrip,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero, // 🔥 important
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Ink(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF397098), Color(0xFF942FAF)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: _isSubmitting
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : Text(
                        AppLocalizations.of(context).intercityPublishTrip,
                        style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 16),
                      ),
              ),
            ),
          ),
        ),
      ),
    ),
    body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            localize(context).intercityTripInstruction,
                            style: const TextStyle(color: Colors.blue, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  const SizedBox(height: 24),
                  _buildSectionHeader(AppLocalizations.of(context).intercityTripDetails),
                  const SizedBox(height: 16),
                  Column(
                    children: [
                      DropdownButtonFormField<String>(
                        value: _selectedBookingType,
                        decoration: _inputDecoration(AppLocalizations.of(context).intercityBookingType),
                        items: _bookingTypes
                            .map(
                              (t) => DropdownMenuItem(
                                value: t,
                                child: Text(
                                  t == 'SHARE_POOL'
                                      ? AppLocalizations.of(context).intercitySharePool
                                      : AppLocalizations.of(context).intercityPrivate,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (val) => setState(() => _selectedBookingType = val!),
                      ),
                      const SizedBox(height: 24),

                      DropdownButtonFormField<String>(
                        value: _selectedVehicleType,
                        decoration: _inputDecoration(localize(context).intercityVehicleType),
                        items: _serviceTypes
                            .map((t) => DropdownMenuItem(value: t, child: Text(_getVehicleTypeText(context, t))))
                            .toList(),
                        onChanged: (val) => setState(() => _selectedVehicleType = val!),
                        validator: (val) => val == null ? AppLocalizations.of(context).intercityRequiredError : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  const SizedBox(height: 24),
                  _buildSectionHeader(AppLocalizations.of(context).intercityRouteSelection),
                  const SizedBox(height: 16),
                  // New Column Layout for From/To
                  _buildLocationAutocomplete(
                    key: _fromInputKey,
                    label: AppLocalizations.of(context).intercityFromCity,
                    controller: _fromController,
                    onItemSelected: (details) {
                      // Pre-fill Pickup
                      final address = details['address'];
                      if (address != null) {
                        setState(() {
                          _pickupLocationController.text = address;
                          _pickupFullAddressController.text = address;
                          _pickupLatController.text = details['lat'].toString();
                          _pickupLngController.text = details['lng'].toString();
                          _pickupInputKey = UniqueKey(); // Force visual update
                        });
                        _attemptRouteMatch();
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildLocationAutocomplete(
                    key: _toInputKey,
                    label: AppLocalizations.of(context).intercityToCity,
                    controller: _toController,
                    onItemSelected: (details) {
                      // Pre-fill Drop
                      final address = details['address'];
                      if (address != null) {
                        setState(() {
                          _dropLocationController.text = address;
                          _dropFullAddressController.text = address;
                          _dropLatController.text = details['lat'].toString();
                          _dropLngController.text = details['lng'].toString();
                          _dropInputKey = UniqueKey(); // Force visual update
                        });
                        _attemptRouteMatch();
                      }
                    },
                  ),

                  const SizedBox(height: 24),

                  _buildSectionHeader(AppLocalizations.of(context).intercityLocationsCoords),
                  const SizedBox(height: 16),
                  _buildLocationAutocomplete(
                    key: _pickupInputKey,
                    label: AppLocalizations.of(context).intercityPickupAddress,
                    controller: _pickupLocationController,
                    latController: _pickupLatController,
                    lngController: _pickupLngController,
                    addressController: _pickupFullAddressController,
                  ),
                  const SizedBox(height: 24),
                  _buildLocationAutocomplete(
                    key: _dropInputKey,
                    label: AppLocalizations.of(context).intercityDropAddress,
                    controller: _dropLocationController,
                    latController: _dropLatController,
                    lngController: _dropLngController,
                    addressController: _dropFullAddressController,
                  ),

                  // Hidden or Read-only Coord fields
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _pickupLatController,
                          readOnly: true,
                          decoration: _inputDecoration(
                            localize(context).intercityPickupLat,
                          ).copyWith(filled: true, fillColor: Colors.grey[100]),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: TextFormField(
                          controller: _pickupLngController,
                          readOnly: true,
                          decoration: _inputDecoration(
                            localize(context).intercityPickupLng,
                          ).copyWith(filled: true, fillColor: Colors.grey[100]),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _dropLatController,
                          readOnly: true,
                          decoration: _inputDecoration(
                            localize(context).intercityDropLat,
                          ).copyWith(filled: true, fillColor: Colors.grey[100]),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: TextFormField(
                          controller: _dropLngController,
                          readOnly: true,
                          decoration: _inputDecoration(
                            localize(context).intercityDropLng,
                          ).copyWith(filled: true, fillColor: Colors.grey[100]),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  const SizedBox(height: 24),
                  _buildSectionHeader(AppLocalizations.of(context).intercityScheduleFare),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => _pickDateTime(isReturn: false),
                          child: InputDecorator(
                            decoration: _inputDecoration(AppLocalizations.of(context).intercityDepartureTime),
                            child: Text(
                              _scheduledDeparture == null
                                  ? AppLocalizations.of(context).intercitySelectDateTime
                                  : DateFormat('dd MMM, hh:mm a').format(_scheduledDeparture!),
                              style: TextStyle(color: _scheduledDeparture == null ? Colors.grey : Colors.black),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _fareController,
                          keyboardType: TextInputType.number,
                          decoration: _inputDecoration(AppLocalizations.of(context).intercityTotalFareInput),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _seatsController,
                          keyboardType: TextInputType.number,
                          decoration: _inputDecoration(AppLocalizations.of(context).intercitySeats),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _distanceController,
                          readOnly: true,
                          decoration: _inputDecoration(AppLocalizations.of(context).intercityDistance).copyWith(
                            suffixIcon: const Icon(Icons.map, color: Colors.blue),
                            filled: true,
                            fillColor: Colors.blue[50],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Checkbox(value: _isReturnTrip, onChanged: (v) => setState(() => _isReturnTrip = v!)),
                            Text(AppLocalizations.of(context).intercityReturnTrip),
                            const Spacer(),
                            Checkbox(
                              value: _isNightFareEnabled,
                              onChanged: (v) => setState(() => _isNightFareEnabled = v!),
                            ),
                            Text(AppLocalizations.of(context).intercityNightFare),
                          ],
                        ),
                        // const SizedBox(height: 16),
                        if (_isReturnTrip)
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: InkWell(
                              onTap: () => _pickDateTime(isReturn: true),
                              child: InputDecorator(
                                decoration: _inputDecoration(AppLocalizations.of(context).intercityReturnDeparture),
                                child: Text(
                                  _returnTripDeparture == null
                                      ? AppLocalizations.of(context).intercitySelectDateTime
                                      : DateFormat('dd MMM, hh:mm a').format(_returnTripDeparture!),
                                  style: TextStyle(color: _returnTripDeparture == null ? Colors.grey : Colors.black),
                                ),
                              ),
                            ),
                          ),
                        if (_isNightFareEnabled)
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: TextFormField(
                              controller: _nightFareMultiplierController,
                              keyboardType: TextInputType.number,
                              decoration: _inputDecoration(AppLocalizations.of(context).intercityNightFareMultiplier),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
  );

  InputDecoration _inputDecoration(String label) => InputDecoration(
    labelText: label,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    isDense: true,
  );

  Widget _buildSectionHeader(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
  );

  String _getVehicleTypeText(BuildContext context, String type) {
    switch (type) {
      case 'CAR_NORMAL':
        return localize(context).intercityVehicleCarNormal;
      case 'CAR_PREMIUM_EXPRESS':
        return localize(context).intercityVehicleCarPremium;
      case 'AUTO_NORMAL':
        return localize(context).intercityVehicleAuto;
      case 'TATA_MAGIC_LITE':
        return localize(context).intercityVehicleTataMagic;
      default:
        return type;
    }
  }
}
