// Modelo de Usuario
class UserModel {
  final int id;
  final String nombre;
  final String correo;
  final double saldoDisponible;

  UserModel({required this.id, required this.nombre, required this.correo, required this.saldoDisponible});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      nombre: json['nombre'],
      correo: json['correo'],
      saldoDisponible: json['saldoDisponible'],
    );
  }
}
