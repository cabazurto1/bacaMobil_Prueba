import 'package:flutter/material.dart';
import '../services/card_service.dart';
import '../models/card_model.dart';

class CardController extends ChangeNotifier {
  final CardService _service = CardService();
  List<CardModel> _cards = [];

  List<CardModel> get cards => _cards;

  Future<void> fetchCards(String userId) async {
    _cards = await _service.getCardsByUser(userId);
    notifyListeners();
  }

  Future<void> addCard(CardModel card) async {
    CardModel newCard = await _service.addCard(card);
    _cards.add(newCard);
    notifyListeners();
  }

  Future<void> freezeCard(String cardId, bool isFrozen) async {
    await _service.freezeCard(cardId, isFrozen);
    int index = _cards.indexWhere((c) => c.id == cardId);
    if (index != -1) {
      _cards[index] = _cards[index].copyWith(isFrozen: isFrozen);
      notifyListeners();
    }
  }

  Future<void> removeCard(String cardId) async {
    await _service.deleteCard(cardId);
    _cards.removeWhere((c) => c.id == cardId);
    notifyListeners();
  }

  Future<CardModel?> getCardById(String cardId) async {
    return await _service.getCardById(cardId);
  }
}
