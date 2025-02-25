class UserModel {
  final String id;
  final String nombre;
  final String correo;
  final String password;

  // Constructor con parámetros requeridos
  UserModel({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.password,
  });

  // Convertir a Map para enviar como JSON al backend
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre, // Se incluye el nombre en el JSON
      'correo': correo,
      'password': password,
    };
  }

  // Crear un objeto `UserModel` desde un Map (JSON recibido del backend)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['_id'] ?? '', // Si `_id` es null, asigna una cadena vacía
      nombre: map['nombre'] ?? 'Sin Nombre', // Si `nombre` es null, pone un valor por defecto
      correo: map['correo'] ?? '',
      password: map['password'] ?? '',
    );
  }

  // Método para convertir `UserModel` a JSON
  String toJson() => toMap().toString();
}
