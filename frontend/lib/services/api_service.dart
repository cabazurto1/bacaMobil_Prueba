import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: "http://localhost:8080/api"));

  Future<Response> login(String email, String password) async {
    return await _dio.post("/auth/login", data: {"email": email, "password": password});
  }

  Future<Response> register(String name, String email, String password) async {
    return await _dio.post("/auth/register", data: {"name": name, "email": email, "password": password});
  }

  Future<Response> getTransactions(String userId) async {
    return await _dio.get("/transactions/$userId");
  }
}
