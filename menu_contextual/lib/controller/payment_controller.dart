import 'package:flutter/material.dart';
import '../services/payment_service.dart';
import '../models/payment_model.dart';

class PaymentController extends ChangeNotifier {
  final PaymentService _service = PaymentService();
  List<PaymentModel> _payments = [];

  List<PaymentModel> get payments => _payments;

  Future<void> fetchPayments(String userId) async {
    _payments = await _service.getPayments(userId);
    notifyListeners();
  }

  Future<void> addPayment(PaymentModel payment) async {
    await _service.createPayment(payment);
    _payments.add(payment);
    notifyListeners();
  }

  Future<void> removePayment(String paymentId) async {
    await _service.deletePayment(paymentId);
    _payments.removeWhere((p) => p.id == paymentId);
    notifyListeners();
  }
}
