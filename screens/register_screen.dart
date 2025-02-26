import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _sessionController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _registerWithEmail() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }
    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Account")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(
                labelText: "First name",
                prefixIcon: Icon(Icons.supervised_user_circle),
              ),
            ),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(
                labelText: "Last name",
                prefixIcon: Icon(Icons.supervised_user_circle_outlined),
              ),
            ),
            TextField(
              controller: _sessionController,
              decoration: const InputDecoration(
                labelText: "Session",
                prefixIcon: Icon(Icons.timelapse),
              ),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: "Password",
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            TextField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(
                labelText: "Repeat password",
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _registerWithEmail,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
              ),
              child: const Text("Enter", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}