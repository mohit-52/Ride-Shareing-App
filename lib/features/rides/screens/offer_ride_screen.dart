import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ride_app/features/rides/models/ride_model.dart';
import 'package:ride_app/services/firebase/firestore_service.dart';
import 'package:ride_app/services/storage/hive_db.dart';

class OfferRidePage extends StatefulWidget {
  const OfferRidePage({super.key});

  @override
  State<OfferRidePage> createState() => _OfferRidePageState();
}

class _OfferRidePageState extends State<OfferRidePage> {
  static const primaryColor = Color(0xFF0E6F5C);
  static const bgColor = Color(0xFFF5F6FA);

  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _fareController =
      TextEditingController(text: '150');

  TimeOfDay _departureTime = const TimeOfDay(hour: 8, minute: 30);
  DateTime _departureDate = DateTime.now();
  int _availableSeats = 3;
  bool _repeatDaily = false;
  bool _isPublishing = false;

  final FirestoreService _firestoreService = FirestoreService();

  String get _formattedTime {
    final hour = _departureTime.hourOfPeriod == 0
        ? 12
        : _departureTime.hourOfPeriod;
    final minute = _departureTime.minute.toString().padLeft(2, '0');
    final period = _departureTime.period == DayPeriod.am ? 'AM' : 'PM';
    return '${hour.toString().padLeft(2, '0')}:$minute $period';
  }

  String get _formattedDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selected = DateTime(_departureDate.year, _departureDate.month, _departureDate.day);

    if (selected == today) return 'Today';
    if (selected == today.add(const Duration(days: 1))) return 'Tomorrow';

    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                     'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${_departureDate.day} ${months[_departureDate.month - 1]}, ${_departureDate.year}';
  }

  /// YYYY-MM-DD format for Firestore queries
  String get _departureDateString {
    return '${_departureDate.year}-'
        '${_departureDate.month.toString().padLeft(2, '0')}-'
        '${_departureDate.day.toString().padLeft(2, '0')}';
  }

  /// HH:MM 24h format for Firestore storage
  String get _departureTimeString {
    return '${_departureTime.hour.toString().padLeft(2, '0')}:'
        '${_departureTime.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _departureTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _departureTime = picked);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _departureDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _departureDate = picked);
    }
  }

  void _incrementSeats() {
    if (_availableSeats < 4) setState(() => _availableSeats++);
  }

  void _decrementSeats() {
    if (_availableSeats > 1) setState(() => _availableSeats--);
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    _fareController.dispose();
    super.dispose();
  }

  Future<void> _publishRide() async {
    // ── Validation ──
    final from = _fromController.text.trim();
    final to = _toController.text.trim();
    final fareText = _fareController.text.trim();

    if (from.isEmpty || to.isEmpty) {
      _showSnackBar('Please enter starting point and destination.');
      return;
    }

    final fare = int.tryParse(fareText);
    if (fare == null || fare <= 0) {
      _showSnackBar('Please enter a valid fare amount.');
      return;
    }

    // ── Get current user data ──
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) {
      _showSnackBar('You must be logged in to publish a ride.');
      return;
    }

    final hiveUser = HiveDB.instance.getUserData();
    final userName = hiveUser?.name ?? 'Unknown';
    final userPhone = firebaseUser.phoneNumber ?? hiveUser?.phoneNo ?? '';

    // ── Build departure datetime ──
    final departureDateTime = DateTime(
      _departureDate.year,
      _departureDate.month,
      _departureDate.day,
      _departureTime.hour,
      _departureTime.minute,
    );

    // ── Prevent publishing past rides ──
    if (departureDateTime.isBefore(DateTime.now())) {
      _showSnackBar('Departure time is in the past. Please select a future time.');
      return;
    }

    setState(() => _isPublishing = true);

    try {
      final journey = JourneyModel(
        id: '',  // Will be auto-generated by Firestore
        captainUid: firebaseUser.uid,
        captainName: userName,
        captainPhone: userPhone,
        fromCity: from.toLowerCase(),
        fromDisplay: from,
        toCity: to.toLowerCase(),
        toDisplay: to,
        departureDate: _departureDateString,
        departureTime: _departureTimeString,
        departureDateTime: Timestamp.fromDate(departureDateTime),
        seatsTotal: _availableSeats,
        farePerSeat: fare,
        status: JourneyStatus.active,
        isRecurring: _repeatDaily,
        createdAt: Timestamp.now(),
      );

      await _firestoreService.create(
        collectionPath: 'journeys',
        data: journey.toMap(),
      );

      if (mounted) {
        _showSnackBar(
          '🚀 Ride published! $_availableSeats seat(s) from $from → $to at $_formattedTime',
          isSuccess: true,
        );

        // Reset form
        _fromController.clear();
        _toController.clear();
        _fareController.text = '150';
        setState(() {
          _availableSeats = 3;
          _repeatDaily = false;
          _departureDate = DateTime.now();
          _departureTime = const TimeOfDay(hour: 8, minute: 30);
        });
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Failed to publish ride: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isPublishing = false);
      }
    }
  }

  void _showSnackBar(String message, {bool isSuccess = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? primaryColor : Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            children: [
              const SizedBox(height: 10),
              const _Header(),
              const SizedBox(height: 24),
              // Title
              const Text(
                'Offer a Ride',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Share your journey and split the costs.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 20),

              // From / To Card
              _cardContainer(
                child: Column(
                  children: [
                    // From row
                    Row(
                      children: [
                        _RouteIndicator(),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'From',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              TextField(
                                controller: _fromController,
                                decoration: InputDecoration(
                                  hintText: 'Enter starting point',
                                  hintStyle:
                                      TextStyle(color: Colors.grey.shade400),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  prefixIcon: const Icon(
                                    Icons.my_location_outlined,
                                    color: Color(0xFF0E6F5C),
                                    size: 18,
                                  ),
                                ),
                              ),
                              const Divider(),
                              Text(
                                'To',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              TextField(
                                controller: _toController,
                                decoration: InputDecoration(
                                  hintText: 'Enter destination',
                                  hintStyle:
                                      TextStyle(color: Colors.grey.shade400),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  prefixIcon: Icon(
                                    Icons.location_on_outlined,
                                    color: Colors.grey.shade400,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Departure Date Card
              _cardContainer(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Departure Date',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                color: primaryColor,
                                size: 22,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _formattedDate,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: _pickDate,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        child: const Icon(
                          Icons.calendar_month_outlined,
                          color: Colors.black87,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Departure Time Card
              _cardContainer(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Departure Time',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                color: primaryColor,
                                size: 22,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _formattedTime,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: _pickTime,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        child: const Icon(
                          Icons.access_time_outlined,
                          color: Colors.black87,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Fare per seat Card
              _cardContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fare per seat',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          '₹',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: TextField(
                            controller: _fareController,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: false),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Available Seats Card
              _cardContainer(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Available Seats',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _SeatIndicator(seats: _availableSeats),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    _SeatCounter(
                      count: _availableSeats,
                      onDecrement: _decrementSeats,
                      onIncrement: _incrementSeats,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Repeat Daily Card
              _cardContainer(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF7F5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.repeat,
                        color: primaryColor,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Repeat daily',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Set as a recurring commute',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _repeatDaily,
                      onChanged: (val) => setState(() => _repeatDaily = val),
                      activeThumbColor: Colors.white,
                      activeTrackColor: primaryColor,
                      inactiveTrackColor: Colors.grey.shade300,
                      inactiveThumbColor: Colors.white,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Publish Ride Button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _isPublishing ? null : _publishRide,
                  icon: _isPublishing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : const Icon(Icons.rocket_launch_outlined, size: 20),
                  label: Text(
                    _isPublishing ? 'Publishing...' : 'Publish Ride',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Center(
                child: Text(
                  'By publishing, you agree to our Community Guidelines.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: child,
    );
  }
}

// ------------------------------------------------------------------
// Route indicator (vertical line with dots) on left of From/To card
// ------------------------------------------------------------------
class _RouteIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Filled dot for "From"
          Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: Color(0xFF0E6F5C),
              shape: BoxShape.circle,
            ),
          ),
          // Dashed vertical line
          ...List.generate(
            4,
            (_) => Container(
              width: 2,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Hollow dot for "To"
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF0E6F5C),
                width: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------------
// Seat icons indicator
// ------------------------------------------------------------------
class _SeatIndicator extends StatelessWidget {
  final int seats;
  const _SeatIndicator({required this.seats});

  static const primaryColor = Color(0xFF0E6F5C);
  static const maxSeats = 4;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        maxSeats,
        (index) => Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Icon(
            Icons.person,
            size: 22,
            color: index < seats ? primaryColor : Colors.grey.shade300,
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------
// Seat counter widget (– / count / +)
// ------------------------------------------------------------------
class _SeatCounter extends StatelessWidget {
  final int count;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _SeatCounter({
    required this.count,
    required this.onDecrement,
    required this.onIncrement,
  });

  static const primaryColor = Color(0xFF0E6F5C);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Decrement button
        GestureDetector(
          onTap: onDecrement,
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF7F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.remove,
              color: primaryColor,
              size: 18,
            ),
          ),
        ),
        // Count
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            '$count',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        // Increment button
        GestureDetector(
          onTap: onIncrement,
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 18,
            ),
          ),
        ),
      ],
    );
  }
}

// ------------------------------------------------------------------
// Header
// ------------------------------------------------------------------
class _Header extends StatelessWidget {
  const _Header();

  static const primaryColor = Color(0xFF0E6F5C);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'SeatShare',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
      ],
    );
  }
}
