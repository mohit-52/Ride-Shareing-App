import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ride_app/features/rides/models/ride_model.dart';
import 'package:ride_app/services/firebase/firestore_service.dart';
import 'package:url_launcher/url_launcher.dart';


class FindRidePage extends StatefulWidget {
  const FindRidePage({super.key});

  @override
  State<FindRidePage> createState() => _FindRidePageState();
}

class _FindRidePageState extends State<FindRidePage> {
  static const primaryColor = Color(0xFF0E6F5C);
  static const bgColor = Color(0xFFF5F6FA);

  final FirestoreService _firestoreService = FirestoreService();

  List<JourneyModel> _searchResults = [];
  bool _isLoading = false;
  bool _hasSearched = false;
  String? _errorMessage;

  Future<void> _searchRides(String fromCity, String toCity, String departureDate) async {
    setState(() {
      _isLoading = true;
      _hasSearched = true;
      _errorMessage = null;
    });

    try {
      final results = await _firestoreService.getCollection<JourneyModel>(
        collectionPath: 'journeys',
        fromMap: JourneyModel.fromMap,
        queryBuilder: (query) => query
            .where('from_city', isEqualTo: fromCity.toLowerCase().trim())
            .where('to_city', isEqualTo: toCity.toLowerCase().trim())
            // .where('departure_date', isEqualTo: departureDate)
            .where('status', isEqualTo: 'active'),
      );

      // Client-side sort by departure_time
      results.sort((a, b) => a.departureTime.compareTo(b.departureTime));

      if (mounted) {
        setState(() {
          _searchResults = results;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = '$e Failed to search rides. Please try again.';
        });
      }
    }
  }

  Future<void> _bookRide(JourneyModel journey) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      _showSnackBar('You must be logged in to book a ride.');
      return;
    }

    // ── Guard: Captain cannot book own ride ──
    if (journey.captainUid == currentUser.uid) {
      _showSnackBar('You cannot join your own journey.');
      return;
    }

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Confirm Booking'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${journey.fromDisplay} → ${journey.toDisplay}'),
            const SizedBox(height: 8),
            Text('Captain: ${journey.captainName}'),
            Text('Fare: ₹${journey.farePerSeat} per seat'),
            Text('Departure: ${_formatDisplayTime(journey.departureTime)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: TextStyle(color: Colors.grey.shade600)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      // ── Guard: Check for duplicate booking ──
      final existingBookings = await _firestoreService.getCollection<Map<String, dynamic>>(
        collectionPath: 'ride_participants',
        fromMap: (data, id) => {'id': id, ...data},
        queryBuilder: (query) => query
            .where('journey_id', isEqualTo: journey.id)
            .where('rider_uid', isEqualTo: currentUser.uid)
            .where('status', whereIn: ['pending', 'confirmed']),
      );

      if (existingBookings.isNotEmpty) {
        if (mounted) {
          _showSnackBar('You already have a booking for this ride.');
        }
        return;
      }

      // ── Create ride_participant record ──
      final now = Timestamp.now();
      await _firestoreService.create(
        collectionPath: 'ride_participants',
        data: {
          'journey_id': journey.id,
          'rider_uid': currentUser.uid,
          'captain_uid': journey.captainUid,
          'status': 'pending',
          'joined_at': now,
          'updated_at': now,
        },
      );

      if (mounted) {
        _showSnackBar('✅ Booking request sent! Waiting for captain\'s confirmation.', isSuccess: true);
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Failed to book ride. Please try again.');
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

  String _formatDisplayTime(String time24) {
    // Convert "08:30" → "08:30 AM"
    try {
      final parts = time24.split(':');
      final hour = int.parse(parts[0]);
      final minute = parts[1];
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
      return '${displayHour.toString().padLeft(2, '0')}:$minute $period';
    } catch (_) {
      return time24;
    }
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
              const Header(),
              const SizedBox(height: 20),
              SearchCard(onSearch: _searchRides),
              const SizedBox(height: 20),

              // Results Header
              if (_hasSearched)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _isLoading
                          ? "Searching..."
                          : "Available Rides (${_searchResults.length})",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    if (_searchResults.isNotEmpty)
                      Text(
                        '${_searchResults.length} found',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                  ],
                )
              else
                const Text(
                  "Search for rides",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

              const SizedBox(height: 10),

              // Loading State
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: CircularProgressIndicator(color: primaryColor),
                  ),
                ),

              // Error State
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.error_outline,
                            size: 48, color: Colors.red.shade300),
                        const SizedBox(height: 12),
                        Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.grey.shade600),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

              // Empty State
              if (!_isLoading &&
                  _errorMessage == null &&
                  _hasSearched &&
                  _searchResults.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.search_off,
                            size: 48, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        Text(
                          'No rides found for this route.\nTry a different date or route.',
                          style: TextStyle(color: Colors.grey.shade600),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

              // Results List
              if (!_isLoading && _errorMessage == null)
                ...List.generate(_searchResults.length, (index) {
                  final journey = _searchResults[index];
                  return RideCard(
                    journey: journey,
                    onBook: () => _bookRide(journey),
                    formatTime: _formatDisplayTime,
                  );
                }),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text(
          "SeatShare",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class SearchCard extends StatefulWidget {
  final Future<void> Function(String fromCity, String toCity, String departureDate) onSearch;

  const SearchCard({super.key, required this.onSearch});

  @override
  State<SearchCard> createState() => _SearchCardState();
}

class _SearchCardState extends State<SearchCard> {
  static const primaryColor = Color(0xFF0E6F5C);

  String _selectedDateLabel = "Today";
  DateTime _selectedDate = DateTime.now();

  String _fromValue = "";
  String _toValue = "";

  /// YYYY-MM-DD format for Firestore query
  String get _departureDateString {
    return '${_selectedDate.year}-'
        '${_selectedDate.month.toString().padLeft(2, '0')}-'
        '${_selectedDate.day.toString().padLeft(2, '0')}';
  }

  void _selectDateDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("Today"),
                leading: const Icon(Icons.calendar_today, color: primaryColor),
                onTap: () {
                  setState(() {
                    _selectedDateLabel = "Today";
                    _selectedDate = DateTime.now();
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Tomorrow"),
                leading: const Icon(Icons.calendar_today_outlined, color: primaryColor),
                onTap: () {
                  setState(() {
                    _selectedDateLabel = "Tomorrow";
                    _selectedDate = DateTime.now().add(const Duration(days: 1));
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Pick a date..."),
                leading: const Icon(Icons.calendar_month, color: primaryColor),
                onTap: () async {
                  Navigator.pop(context);
                  final picked = await showDatePicker(
                    context: this.context,
                    initialDate: _selectedDate,
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
                    final now = DateTime.now();
                    final today = DateTime(now.year, now.month, now.day);
                    String label;
                    if (picked == today) {
                      label = "Today";
                    } else if (picked == today.add(const Duration(days: 1))) {
                      label = "Tomorrow";
                    } else {
                      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                                       'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                      label = '${picked.day} ${months[picked.month - 1]}';
                    }
                    setState(() {
                      _selectedDateLabel = label;
                      _selectedDate = picked;
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _onSearch() {
    if (_fromValue.trim().isEmpty || _toValue.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter both From and To locations.'),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
      return;
    }
    widget.onSearch(_fromValue, _toValue, _departureDateString);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          _inputBox("From", "", (val) => _fromValue = val),
          const SizedBox(height: 10),
          _inputBox("To", "", (val) => _toValue = val),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: _selectDateDialog,
                  child: _smallBox(Icons.calendar_today, _selectedDateLabel),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
              ),
              onPressed: _onSearch,
              icon: const Icon(Icons.search, size: 20),
              label: const Text("Search Rides", style: TextStyle(fontSize: 16)),
            ),
          )
        ],
      ),
    );
  }

  Widget _inputBox(String label, String initialValue, ValueChanged<String> onChanged) {
    final List<String> locations = [
      "Palwal",
      "Gurgaon",
      "Delhi",
      "Faridabad",
      "Noida",
      "Sector 21, GGN",
      "IGI Airport T3",
      "Cyber City, Gurgaon",
      "Huda City Centre"
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 5),
        Autocomplete<String>(
          initialValue: TextEditingValue(text: initialValue),
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<String>.empty();
            }
            return locations.where((String location) {
              return location.toLowerCase().contains(textEditingValue.text.toLowerCase());
            });
          },
          onSelected: (String selection) {
            onChanged(selection);
          },
          fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFEDEFF5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextFormField(
                controller: textEditingController,
                focusNode: focusNode,
                onChanged: onChanged,
                onFieldSubmitted: (String value) {
                  onChanged(value);
                  onFieldSubmitted();
                },
                decoration: InputDecoration(
                  hintText: 'Enter ${label.toLowerCase()} location',
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  isDense: true,
                ),
                style: const TextStyle(fontSize: 16),
              ),
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4.0,
                borderRadius: BorderRadius.circular(12),
                clipBehavior: Clip.antiAlias,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 250),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 64,
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: options.length,
                      separatorBuilder: (context, index) => const Divider(height: 1),
                      itemBuilder: (BuildContext context, int index) {
                        final String option = options.elementAt(index);
                        return ListTile(
                          leading: const Icon(Icons.location_on_outlined, color: Colors.grey),
                          title: Text(option),
                          onTap: () {
                            onSelected(option);
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _smallBox(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFEDEFF5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
}

class RideCard extends StatelessWidget {
  final JourneyModel journey;
  final VoidCallback onBook;
  final String Function(String) formatTime;

  const RideCard({
    super.key,
    required this.journey,
    required this.onBook,
    required this.formatTime,
  });

  static const primaryColor = Color(0xFF0E6F5C);

  @override
  Widget build(BuildContext context) {
    final seatColor = journey.seatsTotal >= 3 ? Colors.green : Colors.orange;

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: primaryColor.withValues(alpha: 0.15),
                child: Text(
                  journey.captainName.isNotEmpty
                      ? journey.captainName[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(journey.captainName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    Row(
                      children: [
                        Icon(Icons.directions_car,
                            color: Colors.grey.shade500, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          '${journey.fromDisplay} → ${journey.toDisplay}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('₹${journey.farePerSeat}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: seatColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${journey.seatsTotal} seats',
                      style: TextStyle(color: seatColor, fontSize: 12),
                    ),
                  )
                ],
              )
            ],
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("DEPARTURE",
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                  Text(formatTime(journey.departureTime),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold))
                ],
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      if (journey.captainPhone.isNotEmpty) {
                        final Uri tel = Uri.parse('tel:${journey.captainPhone}');
                        if (await canLaunchUrl(tel)) {
                          await launchUrl(tel);
                        }
                      }
                    },
                    child: const CircleAvatar(
                      backgroundColor: Color(0xFFEDEFF5),
                      child: Icon(Icons.call),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: onBook,
                    child: const Text("Book"),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}


BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.05),
        blurRadius: 10,
        offset: const Offset(0, 5),
      )
    ],
  );
}