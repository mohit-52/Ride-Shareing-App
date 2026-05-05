import 'package:flutter/material.dart';

class MyTripsScreen extends StatefulWidget {
  const MyTripsScreen({super.key});

  @override
  State<MyTripsScreen> createState() => _MyTripsScreenState();
}

class _MyTripsScreenState extends State<MyTripsScreen> {
  int _selectedTab = 0;

  static const Color _primaryGreen = Color(0xFF1A7A5E);
  static const Color _lightGreen = Color(0xFFE8F5F0);
  static const Color _pendingBg = Color(0xFFF0F0F0);
  static const Color _confirmedBg = Color(0xFFE8F5F0);
  static const Color _textDark = Color(0xFF1A1A1A);
  static const Color _textGrey = Color(0xFF888888);
  static const Color _textMedium = Color(0xFF555555);
  static const Color _cardBg = Color(0xFFFFFFFF);
  static const Color _scaffoldBg = Color(0xFFF5F6FA);
  
  static const Color _upcomingBg = Color(0xFF2EC99A);
  static const Color _tomorrowBg = Color(0xFFF0F0F0);
  static const Color _seatActive = Color(0xFF1A7A5E);
  static const Color _seatInactive = Color(0xFFDDDDDD);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _scaffoldBg,
      floatingActionButton: _selectedTab == 1 // Only show on Posted tab
          ? FloatingActionButton(
              onPressed: () {},
              backgroundColor: _primaryGreen,
              shape: const CircleBorder(),
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            )
          : null,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'My Trips',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: _textDark,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTabBar(),
                    const SizedBox(height: 20),
                    _buildTabContent(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 0:
        return Column(
          children: [
            _buildBookedCard1(),
            const SizedBox(height: 16),
            _buildBookedCard2(),
          ],
        );
      case 1:
        return Column(
          children: [
            _buildPostedCard1(),
            const SizedBox(height: 16),
            _buildPostedCard2(),
            const SizedBox(height: 16),
            _buildStatsRow(),
            const SizedBox(height: 80), // extra padding for FAB
          ],
        );
      case 2:
        return Column(
          children: [
            _buildPastCard1(),
            const SizedBox(height: 16),
            _buildPastCard2(),
            const SizedBox(height: 16),
            _buildPastCard3(),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: const [
              Icon(Icons.directions_car_outlined, color: _primaryGreen, size: 26),
              SizedBox(width: 8),
              Text(
                'SeatShare',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _primaryGreen,
                ),
              ),
            ],
          ),
          const Icon(Icons.notifications_outlined, color: _textDark, size: 26),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    final tabs = ['Booked', 'Posted', 'Past'];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = _selectedTab == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : null,
                ),
                child: Text(
                  tabs[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? _primaryGreen : _textGrey,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ---------------------------------------------------------
  // BOOKED TAB CONTENT
  // ---------------------------------------------------------

  Widget _buildBookedCard1() {
    return _buildCardBase(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBadge('Confirmed', _confirmedBg, _primaryGreen),
              _buildPrice('₹350'),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Oct 28, 08:00 AM',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _textDark),
          ),
          const SizedBox(height: 16),
          _buildRouteIndicator(pickup: 'Palwal Bus Stand', dropoff: 'Huda City Centre, Gurgaon'),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 12),
          _buildDriverRow(name: 'Amit Sharma', vehicle: 'Honda City • White • DL 4C XX 1234'),
          const SizedBox(height: 14),
          _buildActionButton('View Details', _primaryGreen, Colors.white),
        ],
      ),
    );
  }

  Widget _buildBookedCard2() {
    return _buildCardBase(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBadge('Pending Approval', _pendingBg, _textGrey),
              _buildPrice('₹420'),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Oct 30, 09:30 AM',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _textDark),
          ),
          const SizedBox(height: 16),
          _buildRouteIndicator(pickup: 'Sector 15, Faridabad', dropoff: 'Cyber City, Gurgaon'),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 12),
          _buildDriverRow(name: 'Priya Singh', vehicle: 'Hyundai Verna • Black • HR 51 XX 5678'),
          const SizedBox(height: 14),
          _buildActionButton('View Details', _lightGreen, _primaryGreen),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // POSTED TAB CONTENT
  // ---------------------------------------------------------

  Widget _buildPostedCard1() {
    return _buildCardBase(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildPostedRoute('Palwal', 'Gurgaon')),
              const SizedBox(width: 12),
              _buildBadge('Upcoming', _upcomingBg, Colors.white),
            ],
          ),
          const SizedBox(height: 12),
          _buildPostedDateTime('Oct 30, 2024', '09:30 AM'),
          const SizedBox(height: 14),
          _buildAvailability('2/4 seats left', _primaryGreen),
          const SizedBox(height: 10),
          _buildSeatIcons(bookedCount: 2, totalSeats: 4),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPassengerAvatars(count: 2),
              _buildSmallActionButton('Manage Ride', _primaryGreen, Colors.white),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPostedCard2() {
    return _buildCardBase(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildPostedRoute('Sector 21, GGN', 'IGI Airport T3')),
              const SizedBox(width: 12),
              _buildBadge('Tomorrow', _tomorrowBg, _textGrey),
            ],
          ),
          const SizedBox(height: 12),
          _buildPostedDateTime('Oct 31, 2024', '05:45 AM'),
          const SizedBox(height: 14),
          _buildAvailability('4/4 seats left', _textGrey),
          const SizedBox(height: 10),
          _buildSeatIcons(bookedCount: 0, totalSeats: 4),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'No passengers yet',
                style: TextStyle(fontSize: 13, color: _textGrey, fontStyle: FontStyle.italic),
              ),
              _buildSmallActionButton('Manage Ride', _primaryGreen, Colors.white),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildCardBase(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.eco_outlined, color: _primaryGreen, size: 26),
                const SizedBox(height: 8),
                const Text('12kg',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: _primaryGreen)),
                const Text('CO2 Saved', style: TextStyle(fontSize: 13, color: _textGrey)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildCardBase(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.account_balance_wallet_outlined, color: Colors.grey[600], size: 26),
                const SizedBox(height: 8),
                const Text('₹2,450',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _textDark)),
                const Text('Earnings', style: TextStyle(fontSize: 13, color: _textGrey)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------
  // PAST TAB CONTENT
  // ---------------------------------------------------------

  Widget _buildPastCard1() {
    return _buildCardBase(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Oct 15, 2023', style: TextStyle(fontSize: 12, color: _textGrey)),
              _buildCompletedBadge(),
            ],
          ),
          const SizedBox(height: 8),
          const Text('San Francisco to Palo Alto',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textDark)),
          const SizedBox(height: 14),
          _buildPastRoute(
            pickup: 'Salesforce Tower, SF',
            pickupTime: '08:15 AM Pickup',
            dropoff: 'Stanford Campus, PA',
            dropoffTime: '09:05 AM Drop-off',
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPastDriverRow(name: 'David Miller', rating: '4.9', vehicle: 'Tesla Model 3'),
              _buildFarePaid('\$18.50'),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _buildOutlinedButton('Rebook')),
              const SizedBox(width: 10),
              Expanded(child: _buildActionButton('Rate Driver', _textDark, Colors.white)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPastCard2() {
    return _buildCardBase(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Oct 12, 2023', style: TextStyle(fontSize: 12, color: _textGrey)),
              _buildCompletedBadge(),
            ],
          ),
          const SizedBox(height: 8),
          const Text('Oakland to San Jose',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textDark)),
          const SizedBox(height: 14),
          _buildPastRoute(
            pickup: 'Jack London Square',
            pickupTime: '05:30 PM Pickup',
            dropoff: 'San Jose Diridon',
            dropoffTime: '06:45 PM Drop-off',
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPastDriverRow(name: 'Sarah Jenkins', rating: '5.0', vehicle: 'Honda Civic'),
              _buildFarePaid('\$22.00'),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 13),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.check_circle_outline, color: _primaryGreen, size: 18),
                SizedBox(width: 8),
                Text('Rated 5 Stars',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: _textMedium)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPastCard3() {
    return _buildCardBase(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Oct 08, 2023', style: TextStyle(fontSize: 12, color: _textGrey)),
              Text('\$15.00', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: _textDark)),
            ],
          ),
          const SizedBox(height: 8),
          const Text('Mountain View to SF',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: _textDark)),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: _textGrey,
                side: const BorderSide(color: Color(0xFFDDDDDD)),
                padding: const EdgeInsets.symmetric(vertical: 11),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('View Details', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // REUSABLE HELPER METHODS
  // ---------------------------------------------------------

  Widget _buildCardBase({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildBadge(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textColor),
      ),
    );
  }

  Widget _buildPrice(String price) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(price,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: _primaryGreen)),
        const Text('per seat', style: TextStyle(fontSize: 11, color: _textGrey)),
      ],
    );
  }

  Widget _buildRouteIndicator({required String pickup, required String dropoff}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: _primaryGreen, width: 2),
                color: Colors.white,
              ),
            ),
            Container(width: 2, height: 36, color: const Color(0xFFCCCCCC)),
            Container(
              width: 14,
              height: 14,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: _primaryGreen),
            ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('PICKUP',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: _textGrey, letterSpacing: 0.5)),
                  Text(pickup,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: _textDark)),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('DROP-OFF',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: _textGrey, letterSpacing: 0.5)),
                  Text(dropoff,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: _textDark)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDriverRow({required String name, required String vehicle, String? imageUrl}) {
    return Row(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: const Color(0xFFDDDDDD),
              child: Icon(Icons.person, color: Colors.grey[600], size: 26),
            ),
            Positioned(
              bottom: -2,
              right: -2,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFB300),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: const Icon(Icons.star, color: Colors.white, size: 10),
              ),
            ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: _textDark)),
              Text(vehicle, style: const TextStyle(fontSize: 13, color: _textGrey)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String text, Color bgColor, Color textColor) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        child: Text(text, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _buildPostedRoute(String from, String to) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: _primaryGreen),
            ),
            const SizedBox(width: 8),
            Text(from, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textDark)),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4.5),
          child: Container(width: 1.5, height: 20, color: const Color(0xFFCCCCCC)),
        ),
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: _primaryGreen, width: 2),
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            Text(to, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: _textDark)),
          ],
        ),
      ],
    );
  }

  Widget _buildPostedDateTime(String date, String time) {
    return Row(
      children: [
        const Icon(Icons.calendar_today_outlined, size: 14, color: _textGrey),
        const SizedBox(width: 6),
        Text(date, style: const TextStyle(fontSize: 13, color: _textGrey)),
        const SizedBox(width: 16),
        const Icon(Icons.access_time, size: 14, color: _textGrey),
        const SizedBox(width: 6),
        Text(time, style: const TextStyle(fontSize: 13, color: _textGrey)),
      ],
    );
  }

  Widget _buildAvailability(String text, Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Availability', style: TextStyle(fontSize: 13, color: _textGrey)),
        Text(text, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textColor)),
      ],
    );
  }

  Widget _buildSeatIcons({required int bookedCount, required int totalSeats}) {
    return Row(
      children: List.generate(totalSeats, (index) {
        final isBooked = index < bookedCount;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Icon(
            Icons.chair_outlined,
            size: 28,
            color: isBooked ? _seatActive : _seatInactive,
          ),
        );
      }),
    );
  }

  Widget _buildPassengerAvatars({required int count}) {
    return SizedBox(
      height: 36,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ...List.generate(count > 2 ? 2 : count, (index) {
            return Positioned(
              left: index * 22.0,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: const Color(0xFFDDDDDD),
                child: Icon(Icons.person, color: Colors.grey[600], size: 20),
              ),
            );
          }),
          if (count > 2)
            Positioned(
              left: 2 * 22.0,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: const Color(0xFFE0E0E0),
                child: Text(
                  '+${count - 2}',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _textGrey),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSmallActionButton(String text, Color bgColor, Color textColor) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildPastRoute({
    required String pickup,
    required String pickupTime,
    required String dropoff,
    required String dropoffTime,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(width: 12, height: 12, decoration: const BoxDecoration(shape: BoxShape.circle, color: _primaryGreen)),
            Container(width: 2, height: 32, color: const Color(0xFFCCCCCC)),
            Container(width: 12, height: 12, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey[400])),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(pickup, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _textDark)),
              Text(pickupTime, style: const TextStyle(fontSize: 12, color: _textGrey)),
              const SizedBox(height: 12),
              Text(dropoff, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _textDark)),
              Text(dropoffTime, style: const TextStyle(fontSize: 12, color: _textGrey)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPastDriverRow({required String name, required String rating, required String vehicle}) {
    return Row(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: const Color(0xFFDDDDDD),
              child: Icon(Icons.person, color: Colors.grey[600], size: 22),
            ),
            Positioned(
              bottom: -2,
              right: -4,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFB300),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: const Icon(Icons.star, color: Colors.white, size: 9),
              ),
            ),
          ],
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _textDark)),
            Row(
              children: [
                const Icon(Icons.star, size: 12, color: Color(0xFFFFB300)),
                const SizedBox(width: 2),
                Text('$rating • $vehicle', style: const TextStyle(fontSize: 12, color: _textGrey)),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFarePaid(String amount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text('FARE PAID',
            style: TextStyle(fontSize: 10, color: _textGrey, letterSpacing: 0.5, fontWeight: FontWeight.w500)),
        Text(amount, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _primaryGreen)),
      ],
    );
  }

  Widget _buildCompletedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Text(
        'COMPLETED',
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: _textGrey, letterSpacing: 0.5),
      ),
    );
  }

  Widget _buildOutlinedButton(String text) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        foregroundColor: _primaryGreen,
        side: const BorderSide(color: _primaryGreen, width: 1.5),
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
    );
  }


}