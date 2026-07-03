class User {
  final int? id;
  final String email;
  final String password; 

  // constructeur pour recuperer les utilisateurs
  User({
    this.id,
    this.email = 'admin@gmail.com',
    this.password = 'password123',
  });

  // constructeur pour creer un utilisateur en base avec id de type AUTO INCREMENT
  User.sansId({
    required this.email,
    required this.password,
  }) : id = null;

  // convertir la classe User en un Objet map de type cle : valeur
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password' : password
    };
  }

  // conertir un map en une instence de User
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      password: map['password'],
    );
  }
}
