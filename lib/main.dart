import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import './services/database_manager.dart'; // Ajustez ce chemin selon vos dossiers
import 'package:app_to_do_list/views/login_inteface.dart'; // Votre vue de connexion

void main() async {
  // 1. Étape obligatoire pour exécuter du code asynchrone avant le runApp
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  
  // 2. Conserve le Splash Screen affiché pendant le chargement
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  final dbManager = DatabaseManager();

  // 3. On lance le chargement SQL et le chrono en parallèle.
  // L'application attendra que LES DEUX conditions soient remplies.
  await Future.wait([
    dbManager.initDB(), // Charge la base de données de façon sécurisée
    Future.delayed(const Duration(seconds: 5)), // Temps minimum d'affichage du Splash (3 secondes)
  ]);

  // 4. Une fois le temps écoulé ET la base prête, on masque le splash screen
  FlutterNativeSplash.remove();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Todo List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const LoginInterface(),
    );
  }
}
