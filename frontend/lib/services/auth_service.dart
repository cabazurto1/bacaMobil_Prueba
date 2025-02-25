import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  final Dio _dio = Dio(BaseOptions(baseUrl: "http://localhost:8080/api"));

  Future<bool> login(String email, String password) async {
    try {
      Response response = await _dio.post("/auth/login", data: {
        "email": email,
        "password": password
      });

      if (response.statusCode == 200) {
        // Aquí puedes guardar el token si lo necesitas
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error en login: $e");
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    try {
      Response response = await _dio.post("/auth/register", data: {
        "name": name,
        "email": email,
        "password": password
      });

      return response.statusCode == 201;
    } catch (e) {
      print("Error en registro: $e");
      return false;
    }
  }

  // 🔹 Nuevo método para cerrar sesión
  Future<void> signOut() async {
    try {
      // Si tienes un token guardado en almacenamiento local, elimínalo aquí
      notifyListeners(); // Notificar cambios a los widgets que dependen de este servicio
    } catch (e) {
      print("Error al cerrar sesión: $e");
    }
  }
}
