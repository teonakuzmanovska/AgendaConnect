import 'package:client_meeting_scheduler/authentication/login_screen.dart';
import 'package:flutter/material.dart';

void showLogoutConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        backgroundColor: Colors.grey[200],
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text("Cancel", style: TextStyle(color: Colors.brown)),
          ),
          TextButton(
            onPressed: () {
              // Handle logout action here
              Navigator.of(context).pop(); // Close the dialog
              // Navigate to login
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Login()),
              );
              // Perform actual logout operation
            },
            child: const Text("Logout", style: TextStyle(color: Colors.black)),
          ),
        ],
      );
    },
  );
}
