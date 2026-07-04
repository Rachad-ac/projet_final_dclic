import 'package:flutter/material.dart';
import '../services/database_manager.dart';
import './login_inteface.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _initialiserApp();
  }

  Future<void> _initialiserApp() async {
    final dbManager = DatabaseManager();

    // Charge la base de données et attend un minimum de 5 secondes
    await Future.wait([
      dbManager.initDB(),
      Future.delayed(const Duration(seconds: 5)),
    ]);

    if (!mounted) return;
    
    // Redirection automatique vers l'interface de connexion
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginInterface()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Image.asset(
            'assets/images/logo.png',
            width: 140,
            height: 140,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
