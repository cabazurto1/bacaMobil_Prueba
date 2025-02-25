import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/payment_model.dart';

class PaymentService {
  final String baseUrl = "http://127.0.0.1:5000/api/payments";

  Future<List<PaymentModel>> getPayments(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl?userId=$userId'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => PaymentModel.fromJson(json)).toList();
    } else {
      throw Exception("Error al obtener pagos");
    }
  }

  Future<void> createPayment(PaymentModel payment) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(payment.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception("Error al crear el pago");
    }
  }

  Future<void> deletePayment(String paymentId) async {
    final response = await http.delete(Uri.parse('$baseUrl/$paymentId'));

    if (response.statusCode != 200) {
      throw Exception("Error al eliminar el pago");
    }
  }
}
