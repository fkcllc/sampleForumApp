import 'package:fkc1/models/api_response.dart';
import 'package:fkc1/models/user.dart';
import 'package:fkc1/screens/home.dart';
import 'package:fkc1/screens/register.dart';
import 'package:fkc1/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  bool isLoading = false;

  void _loginUser() async {
    // if (formKey.currentState!.validate()) {
    //   setState(() {
    //     isLoading = true;
    //   });

    ApiResponse response = await login(txtEmail.text, txtPassword.text);
    if (response.error == null) {
      _saveAndRedirectToHome(response.data as User);
      // // Navigate to home screen or perform any other action
      // Navigator.of(context).pushAndRemoveUntil(
      //   MaterialPageRoute(builder: (context) => const Home()),
      //   (route) => false,
      // );
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.error.toString()),
          duration: const Duration(seconds: 2),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  void _saveAndRedirectToHome(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', user.token ?? '');
    await prefs.setInt('userId', user.id ?? 0);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const Home()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FKCサンプル Login'), centerTitle: true),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            TextFormField(
              controller: txtEmail,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                // Email validation regex
                final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                if (!emailRegex.hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                contentPadding: EdgeInsets.all(10.0),
              ),
            ),
            const SizedBox(height: 10.0),
            // SizedBox widget to add space between the email and password fields
            TextFormField(
              controller: txtPassword,
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Password',
                contentPadding: EdgeInsets.all(10.0),
              ),
            ),
            const SizedBox(height: 10.0),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 178, 161, 203),
                padding: const EdgeInsets.all(10.0),
              ),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  // Process login
                }
              },
              child: const Text(
                'ログイン',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('アカウントをお持ちでない方は'),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => Register()),
                      (route) => false,
                    );
                  },
                  child: const Text('こちら'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// This is a placeholder for the login screen.
// In a real application, this would contain the login form and logic.
// The Login screen is a StatelessWidget that builds a simple login screen with an AppBar and a Center widget.
