
// class NotificationService {
//   final FlutterLocalNotificationsPlugin notificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   Future<void> initNotification() async {
//     AndroidInitializationSettings initializationSettingsAndroid =
//     const AndroidInitializationSettings('explore');
//
//     var initializationSettingsIOS = DarwinInitializationSettings(
//         requestAlertPermission: true,
//         requestBadgePermission: true,
//         requestSoundPermission: true,
//         onDidReceiveLocalNotification:
//             (int id, String? title, String? body, String? payload) async {});
//
//     var initializationSettings = InitializationSettings(
//         android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
//     await notificationsPlugin.initialize(initializationSettings,
//         onDidReceiveNotificationResponse:
//             (NotificationResponse notificationResponse) async
//             {
//               print("object***********");
//
//             });
//   }
//
//   notificationDetails() {
//     return const NotificationDetails(
//         android: AndroidNotificationDetails('channelId', 'channelName',
//             importance: Importance.max),
//         iOS: DarwinNotificationDetails());
//   }
//
//   Future showNotification(
//       {int id = 0, String? title, String? body, String? payLoad}) async {
//     return notificationsPlugin.show(
//         id, title, body, await notificationDetails());
//   }
// }


// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:projectt/screens/homepage.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
//
// class NotifyHelper {
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
// // initialize notification
//   initializeNotification() async {
//     tz.initializeTimeZones();
//     // this is for latest iOS settings
//     // final IOSInitializationSettings initializationSettingsIOS =
//     // IOSInitializationSettings(
//     //     requestSoundPermission: false,
//     //     requestBadgePermission: false,
//     //     requestAlertPermission: false,
//     //     onDidReceiveLocalNotification: onDidReceiveLocalNotification);
//
//     const AndroidInitializationSettings initializationSettingsAndroid =
//     AndroidInitializationSettings("explore");
//
//     const InitializationSettings initializationSettings =
//     InitializationSettings(
//      // iOS: initializationSettingsIOS,
//       android: initializationSettingsAndroid,
//     );
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         //onSelectNotification: selectNotification,
//     );
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onDidReceiveNotificationResponse:
//             (NotificationResponse notificationResponse) async {});
//   }
//
// //ios Permissions
//   void requestIOSPermissions() {
//     flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//         IOSFlutterLocalNotificationsPlugin>()
//         ?.requestPermissions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//   }
//
//   Future onDidReceiveLocalNotification(
//       int id, String? title, String? body, String? payload) async {
//     // display a dialog with the notification details, tap ok to go to another page
//     Get.dialog(const Text("Welcome"));
//   }
//
// //on tap on notification
//   Future selectNotification(String? payload) async {
//     if (payload != null) {
//       print('notification payload: $payload');
//     } else {
//       print("Notification Done");
//     }
//     Get.to(() => const HomePage());
//     //TODO use Navigator
//   }
//
//   //show notification
//   Future showNotification({
//     //String? image,
//     String? title,
//     String? body,
//     String? payload,
//   }) async =>
//       flutterLocalNotificationsPlugin.show(
//           0, title, body, await _notificationDetails(
//           // image!
//       ),
//           payload: payload);
//
//   Future<String> _loadAssetAsTempFile(String assetPath) async {
//     final byteData = await rootBundle.load(assetPath);
//     final bytes = byteData.buffer.asUint8List();
//     final tempDir = await getTemporaryDirectory();
//     final tempFile = File('${tempDir.path}/notification_image.jpg');
//     await tempFile.writeAsBytes(bytes);
//     return tempFile.path;
//   }
//
//   //final sound = 'sound.wav';
//   Future _notificationDetails(
//       //String image
//       ) async {
//     // final imageFilePath =
//     // image.isNotEmpty ? await _loadAssetAsTempFile(image) : null;
//     return const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'channel id',
//           'channel name',
//           importance: Importance.max,
//
//
//         // priority: Priority.high,
//        //   playSound: true,
//           //sound: RawResourceAndroidNotificationSound(sound.split(".").first),
//           enableVibration: true,
//           largeIcon: DrawableResourceAndroidBitmap('explore'),
//           // styleInformation: imageFilePath != null
//           //     ? BigPictureStyleInformation(
//           //   FilePathAndroidBitmap(imageFilePath),
//           //   largeIcon: FilePathAndroidBitmap(imageFilePath),
//           //   contentTitle: 'Notification Title',
//           //   summaryText: 'Notification Summary Text',
//           // )
//           //     : null,
//         ),
//         // iOS: IOSNotificationDetails(
//         //     // sound: sound
//         // )
//     );
//   }
//
//   void showScheduledNotification({
//     String? body,
//     String? image,
//     String? payload,
//     required DateTime scheduledDate,
//   }) async =>
//       flutterLocalNotificationsPlugin.zonedSchedule(
//           0,
//           "It's time to ",
//           body,
//           tz.TZDateTime.from(scheduledDate, tz.local),
//           await _notificationDetails(
//              // image!
//           ),
//           payload: payload,
//           uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//           androidAllowWhileIdle: true);
//
//
//
//   void cancel(int id) => flutterLocalNotificationsPlugin.cancel(id);
//   void cancelAll() => flutterLocalNotificationsPlugin.cancelAll();
//
//
// }

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:projectt/network/utils.dart';
import 'package:projectt/screens/mainscreens.dart';
import 'package:projectt/screens/places_lists/place_details.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotifyHelper {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

// initialize notification
  initializeNotification() async {
    tz.initializeTimeZones();
    // this is for latest iOS settings
    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
        requestSoundPermission: false,
        requestBadgePermission: false,
        requestAlertPermission: false,
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings("explore");

    final InitializationSettings initializationSettings =
    InitializationSettings(
      iOS: initializationSettingsIOS,
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

//ios Permissions
  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    Get.dialog(const Text("Welcome"));
  }

//on tap on notification
  Future selectNotification(String? payload) async {
    if (payload != null) {
      print('notification payload: $payload');
    } else {
      print("Notification Done");
    }
    Get.to(() => mainScreens());
  }

  //show notification
  Future showNotification({
    int id = 0,
    String? image,
    String? body,
    String? payload,
  }) async =>
      flutterLocalNotificationsPlugin.show(
          id, "It's time to ", body, await _notificationDetails(image!),
          payload: payload);

  Future _notificationDetails(String image) async {
    final largeIconPath = await Utils.downloadFile(
        image,
        "largeIcon");
    final bigPicturePath = await Utils.downloadFile(
        "https://miro.medium.com/max/3840/1*xMuIOwjliGUPjkzukeWKfw.jpeg",
        "bigPicture");
    final styleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath),
      largeIcon: FilePathAndroidBitmap(largeIconPath),
    );
    return NotificationDetails(
        android: AndroidNotificationDetails(
          'channel id',
          'channel name',
          importance: Importance.high,
          priority: Priority.high,
          largeIcon: const DrawableResourceAndroidBitmap('explore'),
          styleInformation: styleInformation,
        ),
        iOS: const IOSNotificationDetails());
  }

  Future showScheduledNotification({
    int id = 0,
    String? title,
    String? body,
    String? image,
    String? payload,
    required DateTime scheduledDate,
  }) async =>
      flutterLocalNotificationsPlugin.zonedSchedule(
          id,
          title,
          body,
          tz.TZDateTime.from(scheduledDate, tz.local),
          await _notificationDetails(image!),
          payload: payload,
          uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
          androidAllowWhileIdle: true);

  void cancel(int id) => flutterLocalNotificationsPlugin.cancel(id);
  void cancelAll() => flutterLocalNotificationsPlugin.cancelAll();
}

