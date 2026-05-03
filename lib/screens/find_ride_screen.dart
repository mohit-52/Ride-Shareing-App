import 'package:flutter/material.dart';


class FindRidePage extends StatelessWidget {
  const FindRidePage({super.key});

  static const primaryColor = Color(0xFF0E6F5C);
  static const bgColor = Color(0xFFF5F6FA);

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
              const SearchCard(),
              const SizedBox(height: 20),
              const Text(
                "Available Rides",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              RideCard(
                name: "Rajesh Kumar",
                rating: "4.9 (42 rides)",
                price: "₹150",
                time: "08:30 AM",
                seats: "2 seats left",
                seatColor: Colors.green,
              ),
              RideCard(
                name: "Amit Sharma",
                rating: "4.7 (18 rides)",
                price: "₹120",
                time: "09:15 AM",
                seats: "1 seat left",
                seatColor: Colors.red,
              ),
              RideCard(
                name: "Sana Mehta",
                rating: "5.0 (5 rides)",
                price: "₹180",
                time: "08:00 AM",
                seats: "3 seats left",
                seatColor: Colors.green,
              ),
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
        // Icon(Icons.menu, size: 28),
        Text(
          "SeatShare",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        // CircleAvatar(
        //   radius: 18,
        //   backgroundColor: Colors.grey,
        //   child: Icon(Icons.person, color: Colors.white),
        // )
      ],
    );
  }
}

class SearchCard extends StatelessWidget {
  const SearchCard({super.key});

  static const primaryColor = Color(0xFF0E6F5C);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          _inputBox("From", "Palwal"),
          const SizedBox(height: 10),
          _inputBox("To", "Gurgaon"),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _smallBox(Icons.calendar_today, "Today")),
              const SizedBox(width: 10),
              Expanded(child: _smallBox(Icons.access_time, "08:00 AM")),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
              ),
              onPressed: () {},
              child: const Text("Search", style: TextStyle(fontSize: 16)),
            ),
          )
        ],
      ),
    );
  }

  Widget _inputBox(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFEDEFF5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(value, style: const TextStyle(fontSize: 16)),
        )
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
  final String name, rating, price, time, seats;
  final Color seatColor;

  const RideCard({
    super.key,
    required this.name,
    required this.rating,
    required this.price,
    required this.time,
    required this.seats,
    required this.seatColor,
  });

  static const primaryColor = Color(0xFF0E6F5C);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    Row(
                      children: [
                        const Icon(Icons.star,
                            color: Colors.orange, size: 16),
                        const SizedBox(width: 4),
                        Text(rating),
                      ],
                    )
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(price,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: seatColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      seats,
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
                  Text(time,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold))
                ],
              ),
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(0xFFEDEFF5),
                    child: const Icon(Icons.call),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () {},
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
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10,
        offset: const Offset(0, 5),
      )
    ],
  );
}