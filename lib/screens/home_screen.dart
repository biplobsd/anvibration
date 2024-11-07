import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const path = '/';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(path),
      ),
      body: Center(
        child: FilledButton.tonal(
          onPressed: () async {
            String? token = await FirebaseMessaging.instance.getToken();
            debugPrint(token);
          },
          child: const Text("Get token"),
        ),
      ),
    );
  }
}
