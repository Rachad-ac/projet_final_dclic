import 'package:flutter/material.dart';

class LoginInterface extends StatelessWidget {
  const LoginInterface({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Action à effectuer lors du clic sur le bouton
          },
          child: const Text('Login'),
        ),
      ),
    );
  }
}