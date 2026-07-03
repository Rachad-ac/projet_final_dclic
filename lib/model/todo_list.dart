class TodoList {
  final int? id;
  final String tache;

  TodoList({
    this.id,
    required this.tache,
  });

  TodoList.sansId({
    required this.tache,
  }) : id = null;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tache': tache,
    };
  }

  factory TodoList.fromMap(Map<String, dynamic> map) {
    return TodoList(
      id: map['id'],
      tache: map['tache'],
    );
  }
}