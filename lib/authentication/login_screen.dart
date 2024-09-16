import 'package:client_meeting_scheduler/authentication/register_screen.dart';
import 'package:client_meeting_scheduler/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  static const String id = "signinScreen";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<Login> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  bool passwordError = false;
  bool emailError = false;
  String loginErrorMessage = "";
  bool loginFail = false;

  Future _login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailTextController.text,
          password: _passwordTextController.text);

      // Navigate to HomeScreen after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        loginFail = true;
        loginErrorMessage = e.message ?? "";

        if (loginErrorMessage ==
            "There is no user record corresponding to this identifier. The user may have been deleted.") {
          emailError = true;
          loginErrorMessage =
              "User does not exist. Please create a new account.";
        } else {
          passwordError = true;
          loginErrorMessage = "Password is incorrect.";
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.asset(
          'assets/images/black_logo.png',
          fit: BoxFit.contain,
          height: 32, // Adjust the height of the image
        ),
      ),
      body: SingleChildScrollView(
        // Allows scrolling when content overflows
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 167), // Space between logo and text
              const Text(
                "Welcome to AgendaConnect!",
                style: TextStyle(
                  color: Colors.brown,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _emailTextController,
                cursorColor: Colors.brown,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(color: Colors.black),
                  errorText: emailError ? loginErrorMessage : null,
                  errorStyle: TextStyle(color: Colors.brown),
                  border: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.brown), // Outline color
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.brown), // Focused border color
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.brown), // Enabled border color
                  ),
                ),
                style: TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordTextController,
                cursorColor: Colors.brown,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: TextStyle(color: Colors.black),
                  errorText: passwordError ? loginErrorMessage : null,
                  errorStyle: TextStyle(color: Colors.brown),
                  border: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.brown), // Outline color
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.brown), // Focused border color
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.brown), // Enabled border color
                  ),
                ),
                obscureText: true,
                style: TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Button color
                  foregroundColor: Colors.white, // Text color
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: _login,
                child: const Text(
                  "Sign In",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(color: Colors.black),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Register()));
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.brown,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
