class UserModel {
  final String id;
  final String correo;
  final String password;

  UserModel({required this.id, required this.correo, required this.password});

  // Método para convertir a Map (para enviar como JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'correo': correo,
      'password': password,
    };
  }

  // Crear un UserModel a partir de un Map (para recibir JSON)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['_id'] ?? '',
      correo: map['correo'] ?? '',
      password: map['password'] ?? '',
    );
  }
}
