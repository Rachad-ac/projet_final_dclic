class User {
  final int? id;
  final String email;
  final String password; 

  // constructeur par défaut pour creer un utilisateur
  User({
    this.id,
    required this.email ,
    required this.password,
  });

  // constructeur pour creer un utilisateur par defaut en base 
  User.admin() 
    : id = 1,
      email = 'admin@gmail.com',
      password = 'password1234';

  // convertir la classe User en un Objet map de type cle : valeur
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password' : password
    };
  }

  // Convertir le Map de la base de données en User
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      email: map['email'] as String,
      password: map['password'] as String,
    );
  }
}
