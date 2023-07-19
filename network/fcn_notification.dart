import 'dart:convert';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class LocalNotificationService {
  static String serverKey =
  "AAAAiBzV3n0:APA91bGsbVErIrHMHjwTWqg16yc6oVKCNw88BD3f1SI6VqBQrXLVdvG8GKS2zwH_JRX0tOfjG1dVJDmCpNeyWv4d9GHReNErarkDJUxCi2BjO40MiqW82QpFk7CGb4Zb0FAai8XfX6wa";
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static void initialize() {
    const InitializationSettings initializationSettings =
        InitializationSettings(android: AndroidInitializationSettings("explore"));
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static void display(RemoteMessage message) async {
    try {
      print("In Notification method");
      Random random = new Random();
      int id = random.nextInt(1000);
      const NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
        "mychanel",
        "my chanel",
        importance: Importance.max,
        priority: Priority.high,
      ));
      print("my id is ${id.toString()}");
      await _flutterLocalNotificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.title,
        notificationDetails,
      );
    } on Exception catch (e) {
      print('Error>>>$e');
    }
  }

  static Future<void> sendNotification(
      {String? title, String? message, String? token}) async {
    print("\n\n\n\n\n\n\n\n\n\n\n\n\n");
    print("token is $token");
    print("\n\n\n\n\n\n\n\n\n\n\n\n\n");
    final data = {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
      "message": message,
    };
    try {
      http.Response r = await http.post(
          Uri.parse("https://fcm.googleapis.com/fcm/send"),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Key=$serverKey'
          },
          body: jsonEncode(<String, dynamic>{
            'notification': <String, dynamic>{'body': message, 'title': title},
            'priority': 'high',
            'data': data,
            "to": "$token"
          }));
      print(r.body);
      if (r.statusCode == 200) {
        print("Done");
      } else {
        print(r.statusCode);
      }
    } catch (e) {
      print('exception $e');
    }
  }
}
