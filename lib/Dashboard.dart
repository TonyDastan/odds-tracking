import 'package:flutter/material.dart';
import 'package:odds_tracker/Home.dart';
import 'main.dart'; // Import the main file to navigate to OddsTrackerPage

void main() {
  runApp(BetDashboardApp());
}

class BetDashboardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bet Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BetDashboardPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class BetDashboardPage extends StatelessWidget {
  final List<BetSite> betSites = [
    BetSite(name: 'Wasafi Bet', color: Colors.green, logo: 'assets/images/wasafibet_logo.png'),
    BetSite(name: 'Mbet', color: Colors.blue, logo: 'assets/images/mbet_logo.png'),
    BetSite(name: 'BetPower', color: Colors.red, logo: 'assets/images/betpower_logo.png'),
    BetSite(name: 'SportBet', color: Colors.orange, logo: 'assets/images/sportybet_logo.png'),
    // Add other bet sites here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bet Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Adjust the number of columns for the layout
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.2, // Adjust for better card size
          ),
          itemCount: betSites.length,
          itemBuilder: (context, index) {
            final betSite = betSites[index];
            return GestureDetector(
              onTap: () {
                // Navigate to OddsTrackerPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OddsTrackerPage()),
                );
              },
              child: Card(
                color: betSite.color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Display bet site logo if available
                    if (betSite.logo.isNotEmpty) ...[
                      Image.asset(
                        betSite.logo,
                        width: 80,
                        height: 80,
                      ),
                      SizedBox(height: 10),
                    ],
                    Text(
                      betSite.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class BetSite {
  final String name;
  final Color color;
  final String logo;

  BetSite({required this.name, required this.color, required this.logo});
}
