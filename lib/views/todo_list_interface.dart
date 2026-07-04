import 'package:app_to_do_list/views/login_inteface.dart';
import 'package:flutter/material.dart';
import '../services/database_manager.dart'; 
import '../model/todo_list.dart';

class TodoListInterface extends StatefulWidget {
  const TodoListInterface({super.key});

  @override
  State<TodoListInterface> createState() => _TodoListInterfaceState();
}

class _TodoListInterfaceState extends State<TodoListInterface> {
  final DatabaseManager _dbManager = DatabaseManager();
  final TextEditingController _addController = TextEditingController();
  final TextEditingController _editController = TextEditingController();
  
  List<TodoList> _taches = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _chargerTaches();
  }

  @override
  void dispose() {
    _addController.dispose();
    _editController.dispose();
    super.dispose();
  }

  // Charger les tâches depuis la base de données
  Future<void> _chargerTaches() async {
    setState(() => _isLoading = true);
    final data = await _dbManager.getAllTaches();
    setState(() {
      _taches = data;
      _isLoading = false;
    });
  }

  // Ajouter une nouvelle tâche
  Future<void> _ajouterTache() async {
    if (_addController.text.trim().isEmpty) return;
    
    final nouvelleTache = TodoList.sansId(
      tache: _addController.text.trim(),
    );
    
    await _dbManager.insertTache(nouvelleTache);
    _addController.clear();
    _chargerTaches();
  }

  // Ouvrir la boîte de dialogue de modification 
  void _afficherDialogueModifier(TodoList todolist) {
    _editController.text = todolist.tache;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Modifier la note', style: TextStyle(fontWeight: FontWeight.bold)),
          content: TextField(
            controller: _editController,
            decoration: const InputDecoration(
              hintText: 'Entrer la nouvelle note',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler', style: TextStyle(color: Colors.orange)),
            ),
            TextButton(
              onPressed: () async {
                if (_editController.text.trim().isNotEmpty) {
                  final tacheModifiee = TodoList(
                    id: todolist.id,
                    tache: _editController.text.trim(),
                  );
                  await _dbManager.updateTache(tacheModifiee);
                  if (!mounted) return;
                  Navigator.pop(context);
                  _chargerTaches();
                }
              },
              child: const Text('Enregistrer', style: TextStyle(color: Colors.indigo)),
            ),
          ],
        );
      },
    );
  }

  // Ouvrir la boîte de dialogue de suppression
  void _afficherDialogueSupprimer(int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Supprimer la note', style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text('Voulez vous vraiment supprimer cette note ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler', style: TextStyle(color: Colors.indigo)),
            ),
            TextButton(
              onPressed: () async {
                await _dbManager.deleteTache(id);
                if (!mounted) return;
                Navigator.pop(context);
                _chargerTaches();
              },
              child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Todo List Home', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Se déconnecter',
            onPressed: () {
              // Redirection vers l'écran de connexion
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginInterface()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Zone de saisie supérieure (Nouvelle note + Bouton +)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _addController,
                    decoration: InputDecoration(
                      hintText: 'Nouvelle note',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: _ajouterTache,
                  ),
                ),
              ],
            ),
          ),
          
          // Liste des tâches
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _taches.isEmpty
                    ? const Center(child: Text('Aucune tâche pour le moment'))
                    : ListView.builder(
                        itemCount: _taches.length,
                        itemBuilder: (context, index) {
                          final item = _taches[index];
                          return Container(
                            alignment: Alignment.center,
                            height: 70,
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color.fromARGB(255, 141, 128, 252).withAlpha(200), // Opacité légère (~15%)
                                  blurRadius: 4,                      // Floutage doux de la bordure
                                  offset: const Offset(0, 4),         // Décalage vertical vers le bas uniquement
                                ),
                              ],
                            ),
                            child: ListTile(
                              title: Text(item.tache),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Icône Modifier (Crayon jaune)
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.yellow),
                                    onPressed: () => _afficherDialogueModifier(item),
                                  ),
                                  // Icône Supprimer (Poubelle rouge)
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                                    onPressed: () => _afficherDialogueSupprimer(item.id!),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
