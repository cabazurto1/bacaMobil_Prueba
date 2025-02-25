class UserModel {
  final String id;
  final String nombre;
  final String correo;
  final String password;
  final double saldoDisponible;

  UserModel({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.password,
    this.saldoDisponible = 0.0, // Valor por defecto
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['_id'] ?? '',
      nombre: map['nombre'] ?? 'Sin Nombre',
      correo: map['correo'] ?? '',
      password: map['password'] ?? '',
      saldoDisponible: (map['saldoDisponible'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'correo': correo,
      'password': password,
      'saldoDisponible': saldoDisponible,
    };
  }
}
