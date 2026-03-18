// This screen is the splash/loading screen displayed when the app starts.
// It shows an app logo, title, subtitle, and a loading indicator, then
// automatically navigates to the dashboard after a short delay.

import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

  // Timer to navigate to dashboard after 2 seconds
    Timer(const Duration(seconds: 2), () {
      if (!mounted) return; //Ensure that widget is still in the tree
      Navigator.pushReplacementNamed(context, '/dashboard');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 46,
                backgroundColor: Colors.green.shade100,
                child: Icon(
                  Icons.explore,
                  size: 50,
                  color: Colors.green.shade800,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Expedition Planner',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Plan routes, gear, logs, and budgets in one place.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}