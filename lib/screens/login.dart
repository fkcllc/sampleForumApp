import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: const Center(child: Text('Login Screen')),
    );
  }
}

// This is a placeholder for the login screen.
// In a real application, this would contain the login form and logic.
// The Login screen is a StatelessWidget that builds a simple login screen with an AppBar and a Center widget.
