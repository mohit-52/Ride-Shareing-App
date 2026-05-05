import 'package:flutter/material.dart';
import '../../rides/screens/find_ride_screen.dart';
import '../../rides/screens/offer_ride_screen.dart';
import '../../trips/screens/my_trips_Screen.dart';
import '../../profile/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  static const Color _primaryGreen = Color(0xFF0E6F5C);

  final List<Widget> _screens = [
    const FindRidePage(),
    const OfferRidePage(),
    const MyTripsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, -4),
            )
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: _primaryGreen,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 0,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: _currentIndex == 1 ? _primaryGreen : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add,
                  color: _currentIndex == 1 ? Colors.white : Colors.grey,
                  size: 18,
                ),
              ),
              label: 'Post',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.directions_car),
              label: 'My Trips',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
