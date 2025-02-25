import 'package:flutter/material.dart';
import '../services/notification_service.dart';
import '../models/notification_model.dart';

class NotificationController extends ChangeNotifier {
  final NotificationService _service = NotificationService();
  List<NotificationModel> _notifications = [];

  List<NotificationModel> get notifications => _notifications;

  Future<void> fetchNotifications(String userId) async {
    _notifications = await _service.getNotifications(userId);
    notifyListeners();
  }

  Future<void> markAsRead(String notificationId) async {
    await _service.markAsRead(notificationId);
    _notifications = _notifications.map((n) {
      if (n.id == notificationId) {
        return NotificationModel(
          id: n.id,
          userId: n.userId,
          title: n.title,
          message: n.message,
          read: true,
        );
      }
      return n;
    }).toList();
    notifyListeners();
  }

  Future<void> addNotification(NotificationModel notification) async {
    await _service.createNotification(notification);
    _notifications.add(notification);
    notifyListeners();
  }

  Future<void> removeNotification(String notificationId) async {
    await _service.deleteNotification(notificationId);
    _notifications.removeWhere((n) => n.id == notificationId);
    notifyListeners();
  }
}
