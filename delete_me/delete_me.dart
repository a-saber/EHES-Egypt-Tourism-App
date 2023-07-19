import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'delete_me_two.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'package:http/http.dart' as http;

String? trans;
Future<String> translateText(String inputText, String sourceLang, String targetLang) async {
  var url = Uri.parse('https://api.mymemory.translated.net/get?q=$inputText&langpair=$sourceLang|$targetLang');
  var response = await http.get(url);
  if (response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    return responseBody['responseData']['translatedText'];
  } else {
    throw Exception('Failed to translate text');
  }
}


String serverToken =
    "AAAAiBzV3n0:APA91bGsbVErIrHMHjwTWqg16yc6oVKCNw88BD3f1SI6VqBQrXLVdvG8GKS2zwH_JRX0tOfjG1dVJDmCpNeyWv4d9GHReNErarkDJUxCi2BjO40MiqW82QpFk7CGb4Zb0FAai8XfX6wa";
class DeleteMe extends StatefulWidget {
  const DeleteMe({Key? key}) : super(key: key);

  @override
  State<DeleteMe> createState() => _DeleteMeState();
}

class _DeleteMeState extends State<DeleteMe> {

  sendNotify({
    required String id,
    required String title,
    required String body,
}) async
  {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverToken',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': 'this is a body',
              'title': 'this is a title'
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done',
              "hi": "hay"
            },
            'to': await FirebaseMessaging.instance.getToken(),
           // 'to' : "/topics/saber"
          },
        ),
      ).then((value) {
        print(value.body.toString());
        print(value.statusCode);
      }).catchError((error){
        print(error.toString());
      });
    }


  requestPermission() async
  {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }
  initialMessage() async
  {
    //on tap message while termination case not background
    print('tabbed from terminated case');
    var message = await FirebaseMessaging.instance.getInitialMessage();
    if (message != null){
      navigateTo(context, DeleteMeTwo());
    }
  }
  @override
  void initState() {
    FirebaseMessaging.onMessageOpenedApp.listen((event)
    {
      //on tap message while  background not terminated case
      print('tabbed from background');
      navigateTo(context, DeleteMeTwo());
    });

   initialMessage();
   requestPermission();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: ()async
        {
          trans= await translateText("اسمي هو زهره", "ar","en");
          setState((){});
        }, icon: Icon(Icons.translate)),
      ),
      body:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(trans??"not yet"),
          SizedBox(height: 40,),

          TextButton(
              onPressed: ()
              {
                sendNotify(id: '1', title: 'welcone', body: 'happy');
              },
              child: Text('send')),
          SizedBox(height: 40,),
          TextButton(
              onPressed: () async
              {
                // subscribe to topic on each app start-up
                await FirebaseMessaging.instance.subscribeToTopic('saber');
              },
              child: Text('subscribeToTopic')),
          SizedBox(height: 40,),
          TextButton(
              onPressed: () async
              {
                await FirebaseMessaging.instance.unsubscribeFromTopic('saber');
              },
              child: Text('unsubscribeFromTopic')),
        ],
      ),
    );
  }
}


void navigateTo(context, Widget widget) => Navigator.push(
  context,
  MaterialPageRoute(builder: (BuildContext context) => widget),
);

void navigateAndFinish(context, Widget widget) => Navigator.pushAndRemoveUntil(
context, MaterialPageRoute(builder: (BuildContext context) => widget),
(route) {
return false;
});