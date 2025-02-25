import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/notification_model.dart';

class NotificationService {
  final String baseUrl = 'http://localhost:5000/api/notifications';

  Future<List<NotificationModel>> getNotifications(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl?userId=$userId'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => NotificationModel.fromJson(item)).toList();
    } else {
      throw Exception('Error al obtener notificaciones');
    }
  }

  Future<void> markAsRead(String notificationId) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$notificationId/mark-as-read'),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al marcar la notificación como leída');
    }
  }

  Future<void> createNotification(NotificationModel notification) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(notification.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Error al crear la notificación');
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$notificationId'),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar la notificación');
    }
  }
}
