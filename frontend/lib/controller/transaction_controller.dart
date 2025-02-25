import 'package:flutter/material.dart';
import '../services/transaction_service.dart';
import '../models/transaction_model.dart';

class TransactionController extends ChangeNotifier {
  final TransactionService _service = TransactionService();
  List<TransactionModel> _transactions = [];

  List<TransactionModel> get transactions => _transactions;

  // Obtener transacciones de un pago
  Future<void> fetchTransactions(String paymentId) async {
    _transactions = await _service.getTransactions(paymentId);
    notifyListeners();
  }

  // Agregar una nueva transacción
  Future<void> addTransaction(TransactionModel transaction) async {
    await _service.createTransaction(transaction);
    _transactions.add(transaction);
    notifyListeners();
  }

  // Actualizar una transacción
  Future<void> updateTransaction(String transactionId, Map<String, dynamic> updates) async {
    await _service.updateTransaction(transactionId, updates);
    int index = _transactions.indexWhere((t) => t.id == transactionId);
    if (index != -1) {
      _transactions[index] = TransactionModel.fromJson({..._transactions[index].toJson(), ...updates});
      notifyListeners();
    }
  }

  // Eliminar una transacción
  Future<void> removeTransaction(String transactionId) async {
    await _service.deleteTransaction(transactionId);
    _transactions.removeWhere((t) => t.id == transactionId);
    notifyListeners();
  }
}
