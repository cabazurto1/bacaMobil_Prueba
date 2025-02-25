import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/transaction_model.dart';

class TransactionService {
  final String baseUrl = "http://localhost:5000/api/transactions";

  // Obtener transacciones de un pago específico
  Future<List<TransactionModel>> getTransactions(String paymentId) async {
    final response = await http.get(Uri.parse('$baseUrl?paymentId=$paymentId'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => TransactionModel.fromJson(item)).toList();
    } else {
      throw Exception('Error al obtener transacciones');
    }
  }

  // Crear una nueva transacción
  Future<void> createTransaction(TransactionModel transaction) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(transaction.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Error al crear transacción');
    }
  }

  // Actualizar una transacción
  Future<void> updateTransaction(String transactionId, Map<String, dynamic> updates) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$transactionId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(updates),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar transacción');
    }
  }

  // Eliminar una transacción
  Future<void> deleteTransaction(String transactionId) async {
    final response = await http.delete(Uri.parse('$baseUrl/$transactionId'));

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar transacción');
    }
  }
}
