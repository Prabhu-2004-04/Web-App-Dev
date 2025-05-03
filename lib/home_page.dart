import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'profile_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  final User? user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String moistureValue = "Loading...";
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    fetchMoistureValue();
    _pages = [
      _buildHome(),
      ProfilePage(user: widget.user!),
      SettingsPage(user: widget.user!),
    ];
  }

  void fetchMoistureValue() async {
    final String databaseUrl = "https://smart-c7a94-default-rtdb.firebaseio.com/";
    final DatabaseReference ref = FirebaseDatabase.instance.refFromURL(databaseUrl).child("sensor/soil_moisture");
    try {
      final snapshot = await ref.get();
      if (snapshot.exists) {
        setState(() {
          moistureValue = snapshot.value?.toString() ?? "No data available.";
        });
      } else {
        setState(() {
          moistureValue = "No data available.";
        });
      }
    } catch (e) {
      setState(() {
        moistureValue = "Error fetching data.";
      });
    }
  }

  Widget _buildHome() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Hi, ${widget.user?.displayName ?? "Farmer"} 👩‍🌾', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 8,
            margin: EdgeInsets.symmetric(horizontal: 24),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Text('Current Soil Moisture', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
                  SizedBox(height: 10),
                  Text(
                    '$moistureValue%',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Farming', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        elevation: 10,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
