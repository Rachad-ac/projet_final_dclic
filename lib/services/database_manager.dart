import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/user.dart';
import '../model/todo_list.dart';

class DatabaseManager {
  Database? _database;

  // Getter pour récupérer ou initialiser la base de données
  Future<Database> get database async {
    if (_database != null) return _database!;
    await initDB();
    return _database!;
  }

  // Initialisation de la base de donnees et creation des tables
  Future<void> initDB() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'todo_list.db'),
      onCreate: (db, version) async {
        var batch = db.batch();
        
        // 1. Création de la table users
        batch.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT,
            password TEXT
          )
        ''');
        
        // 2. Création de la table todo_list
        batch.execute('''
          CREATE TABLE todo_list(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            tache TEXT
          )
        ''');
        
        // 3. Création d'un utilisateur par défaut au premier démarrage
        batch.insert(
          'users', 
          User.admin().toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore
        );
        
        await batch.commit();
      },
      version: 1,
    );
  }

  // Méthode de Login / Connexion
  // Retourne un objet User si les identifiants sont corrects, sinon null
  Future<User?> loginUser(String email, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (maps.isNotEmpty) {
      // Utilisation directe du constructeur factory fromMap
      return User.fromMap(maps.first);
    }
    return null; 
  }


  // Insertion d'un utilisateur en base
  Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert(
      'users', 
      user.toMap());
  }

  // Insertion d'une tache en base
  Future<void> insertTache(TodoList todolist) async {
    final db = await database;
    await db.insert(
      'todo_list', 
      todolist.toMap());
  }

  // Mise a jour d'une tache en base
  Future<void> updateTache(TodoList todolist) async {
    final db = await database;
    await db.update(
      'todo_list',
      todolist.toMap(),
      where: 'id = ?',
      whereArgs: [todolist.id],
    );
  }

  // Suppresion d'une tache
  Future<void> deleteTache(int id) async {
    final db = await database;
    await db.delete('todo_list', 
    where: 'id = ?', 
    whereArgs: [id]);
  }

  // Recuperation de tous les taches dans la base
  Future<List<TodoList>> getAllTaches() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'todo_list',
    );
    return List.generate(maps.length, (i) {
      return TodoList(
        id: maps[i]['id'],
        tache: maps[i]['tache'],
      );
    });
  }
}
