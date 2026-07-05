import 'package:app_to_do_list/views/login_inteface.dart';
import 'package:flutter/material.dart';
import '../services/database_manager.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

   // Initialise la base de données en arrière-plan
  final dbManager = DatabaseManager();
  await dbManager.initDB();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const LoginInterface(),
    );
  }
}
