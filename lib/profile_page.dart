import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  const ProfilePage({required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<FlSpot> moistureData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSoilMoistureData();
  }

  void fetchSoilMoistureData() async {
    final ref = FirebaseDatabase.instance
        .refFromURL("https://smart-c7a94-default-rtdb.firebaseio.com/")
        .child("sensor/soil_moisture_history");

    try {
      final snapshot = await ref.get();
      if (snapshot.exists) {
        Map<dynamic, dynamic> data = snapshot.value as Map;
        List<FlSpot> spots = [];
        int index = 0;

        data.forEach((key, value) {
          double moisture = double.tryParse(value["moisture_value"].toString()) ?? 0;
          spots.add(FlSpot(index.toDouble(), moisture));
          index++;
        });

        setState(() {
          moistureData = spots;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching moisture data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile"), backgroundColor: Colors.green),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Section
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.green,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              widget.user.email ?? "No email",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            // Moisture Chart Section
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      "Soil Moisture History",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : moistureData.isNotEmpty
                        ? SizedBox(
                      height: 300,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(show: true),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: true),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          borderData: FlBorderData(show: true),
                          minX: 0,
                          maxX: (moistureData.length - 1).toDouble(),
                          minY: 0,
                          maxY: 100,
                          lineBarsData: [
                            LineChartBarData(
                              spots: moistureData,
                              isCurved: true,
                              gradient: LinearGradient(
                                colors: [Colors.blue, Colors.green],
                              ),
                              barWidth: 4,
                          belowBarData: BarAreaData(
                            show: true,
                            color: Colors.blue.withOpacity(0.3),
                          ),
                        ),

                          ],
                        ),
                      ),
                    )
                        : const Text("No moisture data available."),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Weather Checker Section
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                leading: Icon(Icons.cloud, color: Colors.blue),
                title: Text('Live Weather Checker'),
                subtitle: Text('Click to view current weather'),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InAppWebViewPage()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InAppWebViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Weather Checker"), backgroundColor: Colors.green),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse("https://www.weatherchecker.com")),
        onLoadStart: (controller, url) {
          print("Loading started: $url");
        },
        onLoadStop: (controller, url) async {
          print("Loading stopped: $url");
        },
      ),
    );
  }
}
