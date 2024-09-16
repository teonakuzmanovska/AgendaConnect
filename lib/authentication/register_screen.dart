import 'package:client_meeting_scheduler/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});
  static const String id = "registerScreen";

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<Register> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();

  Future _register() async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailTextController.text,
              password: _passwordTextController.text)
          .then((value) => Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeScreen())));
      ;
    } on FirebaseAuthException catch (e) {
      print("ERROR!");
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Sign Up",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        // Add SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 40), // Adjust for better spacing
                Image.asset(
                  'assets/images/white_logo.png',
                  width: 300,
                  height: 100,
                ),
                const SizedBox(height: 30), // Space between logo and text
                const Text(
                  "Create an Account",
                  style: TextStyle(
                    color: Colors.brown,
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
                  ),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _emailTextController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.brown),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.brown),
                    ),
                  ),
                  style: const TextStyle(color: Colors.black),
                  cursorColor: Colors.brown, // Brown cursor color
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordTextController,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.brown),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.brown),
                    ),
                  ),
                  obscureText: true,
                  style: const TextStyle(color: Colors.black),
                  cursorColor: Colors.brown, // Brown cursor color
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // Button color
                    foregroundColor: Colors.white, // Text color
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: _register,
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 20), // Adjust for overflow safety
              ],
            ),
          ),
        ),
      ),
    );
  }
}
