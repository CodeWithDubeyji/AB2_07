import 'package:flutter/material.dart';

class Notification {
  final String bloodType;
  final bool isNew;
  final String message;

  Notification({
    required this.bloodType,
    required this.isNew,
    required this.message,
  });
}

// notifications_provider.dart


class NotificationsProvider extends ChangeNotifier {
  List<Notification> _notifications = [
    Notification(
      bloodType: "B+",
      isNew: true,
      message: "BLOOD TYPE B+ REQUIRED NEAR BY YOUR LOCATION",
    ),
    Notification(
      bloodType: "O+",
      isNew: true,
      message: "BLOOD TYPE O+ REQUIRED NEAR BY YOUR LOCATION",
    ),
    Notification(
      bloodType: "",
      isNew: true,
      message: "INVITE YOUR FRIENDS AND COLLEGUES FOR NEW BLOOD DONATION CAMPAIGN.",
    ),
    Notification(
      bloodType: "AB+",
      isNew: true,
      message: "BLOOD TYPE AB+ REQUIRED NEAR BY YOUR LOCATION",
    ),
    Notification(
      bloodType: "B-",
      isNew: true,
      message: "BLOOD TYPE B- REQUIRED NEAR BY YOUR LOCATION",
    ),
    Notification(
      bloodType: "B+",
      isNew: true,
      message: "BLOOD TYPE B+ REQUIRED NEAR BY YOUR LOCATION",
    ),
    Notification(
      bloodType: "AB+",
      isNew: true,
      message: "BLOOD TYPE AB+ REQUIRED NEAR BY YOUR LOCATION",
    ),
    Notification(
      bloodType: "O-",
      isNew: true,
      message: "BLOOD TYPE O- REQUIRED NEAR BY YOUR LOCATION",
    ),
    Notification(
      bloodType: "O-",
      isNew: true,
      message: "BLOOD TYPE O- REQUIRED NEAR BY YOUR LOCATION",
    ),
    Notification(
      bloodType: "O-",
      isNew: true,
      message: "BLOOD TYPE O- REQUIRED NEAR BY YOUR LOCATION",
    ),
    Notification(
      bloodType: "O-",
      isNew: true,
      message: "BLOOD TYPE O- REQUIRED NEAR BY YOUR LOCATION",
    ),
  ];

  List<Notification> get notifications => _notifications;
  
  int get newNotificationsCount => _notifications.where((notification) => notification.isNew).length;

  void markAllAsRead() {
    for (var i = 0; i < _notifications.length; i++) {
      if (_notifications[i].isNew) {
        _notifications[i] = Notification(
          bloodType: _notifications[i].bloodType,
          isNew: false,
          message: _notifications[i].message,
        );
      }
    }
    notifyListeners();
  }
  void removeNotification(int index) {
    _notifications.removeAt(index);
    notifyListeners(); // Notify UI to rebuild
  }
}
