import 'package:client_meeting_scheduler/authentication/login_screen.dart';
import 'package:client_meeting_scheduler/firebase_options.dart';
import 'package:client_meeting_scheduler/screens/home_screen.dart';
import 'package:client_meeting_scheduler/services/location_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure Flutter is initialized before Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LocationProvider>(
          create: (_) => LocationProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Client Meetings Scheduler',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              // User is logged in
              if (snapshot.hasData) {
                return HomeScreen(); // Show HomeScreen if user is logged in
              } else {
                return const Login(); // Show Login if user is not logged in
              }
            }
            // Show a loading indicator while checking authentication state
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
