import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/card_model.dart';

class CardService {
  final String baseUrl = 'http://localhost:8080/api/cards';

  Future<List<CardModel>> getCardsByUser(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/user/$userId'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => CardModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener las tarjetas');
    }
  }

  Future<CardModel> getCardById(String cardId) async {
    final response = await http.get(Uri.parse('$baseUrl/$cardId'));

    if (response.statusCode == 200) {
      return CardModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al obtener la tarjeta');
    }
  }

  Future<CardModel> addCard(CardModel card) async {
    final response = await http.post(
      Uri.parse('$baseUrl/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(card.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return CardModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al agregar la tarjeta');
    }
  }

  Future<void> freezeCard(String cardId, bool isFrozen) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$cardId/freeze'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(isFrozen),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al congelar/descongelar la tarjeta');
    }
  }

  Future<void> deleteCard(String cardId) async {
    final response = await http.delete(Uri.parse('$baseUrl/$cardId'));

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar la tarjeta');
    }
  }
}
