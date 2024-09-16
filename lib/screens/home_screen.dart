import 'package:client_meeting_scheduler/authentication/logout_prompt.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.asset(
          'assets/images/black_logo.png',
          fit: BoxFit.contain,
          height: 32, // Adjust the height of the image
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            color: Colors.white,
            onPressed: () {
              showLogoutConfirmationDialog(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Upcoming Meetings Section
            const Text(
              "Upcoming Meetings",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 120, // Adjust the height as necessary
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5, // Sample number of meetings
                itemBuilder: (context, index) {
                  return Card(
                    child: Container(
                      width: 180,
                      padding: EdgeInsets.all(8), // Reduced padding
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Client: ABC Corp",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 6), // Reduced space between lines
                          Text("Date: 21st Sep 2024"),
                          Text("Time: 2:00 PM"),
                          Text("Status: Confirmed"),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Quick Actions Section
            const Text(
              "Quick Actions",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Schedule new meeting action
                    },
                    icon: Icon(Icons.add),
                    label: const Text("New Meeting"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // View calendar action
                    },
                    icon: Icon(Icons.calendar_today),
                    label: const Text("View Calendar"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Calendar Section (Placeholder for now)
            const Text(
              "Calendar Overview",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 100, // Adjust calendar height
              color: Colors.grey[200],
              child: Center(
                child: const Text("Calendar Widget Placeholder"),
              ),
            ),
            const SizedBox(height: 20),

            // Recent Activity Section
            const Text(
              "Recent Activity",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 10),
            const Column(
              children: [
                ListTile(
                  leading: Icon(Icons.update, color: Colors.brown),
                  title: Text("Rescheduled meeting with XYZ Co."),
                  subtitle: Text("2 hours ago"),
                ),
                ListTile(
                  leading: Icon(Icons.update, color: Colors.brown),
                  title: Text("New meeting with ABC Corp."),
                  subtitle: Text("Yesterday"),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Client Directory Section (Placeholder)
            const Text(
              "Client Directory",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 10),
            const Column(
              children: [
                ListTile(
                  leading: Icon(Icons.person, color: Colors.brown),
                  title: Text("ABC Corp."),
                  subtitle: Text("3 meetings"),
                ),
                ListTile(
                  leading: Icon(Icons.person, color: Colors.brown),
                  title: Text("XYZ Co."),
                  subtitle: Text("2 meetings"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
