import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class UserService {
  final String baseUrl = "http://localhost:8080/api/users";

  // Registrar un nuevo usuario con nombre
  Future<UserModel> registerUser(UserModel user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'nombre': user.nombre,
        'correo': user.correo,
        'password': user.password,
      }),
    );
    if (response.statusCode == 201) {
      return UserModel.fromMap(json.decode(response.body));
    } else {
      throw Exception('Error al registrar usuario: ${response.body}');
    }
  }

  // Login de usuario
  Future<UserModel> loginUser(String correo, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'correo': correo,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      return UserModel.fromMap(json.decode(response.body));
    } else {
      throw Exception('Error al iniciar sesión: ${response.body}');
    }
  }

  // Obtener un usuario por ID
  Future<UserModel> getUserById(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/$userId'));
    if (response.statusCode == 200) {
      return UserModel.fromMap(json.decode(response.body));
    } else {
      throw Exception('Usuario no encontrado: ${response.body}');
    }
  }

  // ✅ **Actualizar un usuario (Corregido)**
  Future<UserModel> updateUser(String userId, UserModel updatedUser) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$userId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nombre': updatedUser.nombre,
          'correo': updatedUser.correo,
          'password': updatedUser.password,
        }),
      );

      if (response.statusCode == 200) {
        return UserModel.fromMap(json.decode(response.body));
      } else {
        throw Exception('Error al actualizar usuario: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error en updateUser: $e');
    }
  }

  // Eliminar un usuario
  Future<void> deleteUser(String userId) async {
    final response = await http.delete(Uri.parse('$baseUrl/$userId'));
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar usuario: ${response.body}');
    }
  }
}
