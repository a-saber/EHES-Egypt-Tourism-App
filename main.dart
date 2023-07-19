import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:projectt/authontication/forgetpassword.dart';
import 'package:projectt/authontication/login.dart';
import 'package:projectt/authontication/register.dart';
import 'package:projectt/cubit/cubit.dart';
import 'package:projectt/cubit/state.dart';
import 'package:projectt/network/sharedpreference.dart';
import 'package:projectt/screens/profile/editProfile.dart';
import 'package:projectt/screens/endpoint.dart';
import 'package:projectt/screens/mainscreens.dart';
import 'package:projectt/screens/profile/profile.dart';
import 'package:projectt/screens/splashscreen.dart';
import 'package:projectt/authontication/welcomepage.dart';
import 'package:url_launcher/url_launcher.dart';

import 'delete_me/delete_me.dart';
import 'firebase_options.dart';
import 'network/fcn_notification.dart';
import 'network/local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> checkLocationPermission(context) async {
  var status = await Permission.locationWhenInUse.status;
  if (status.isDenied) {
    if (await Permission.locationWhenInUse.request().isGranted) {
      // Permission granted, continue with location-based tasks.
    } else {
      // Permission denied, show a message to the user.
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Location permission is required to use this feature.'),
        action: SnackBarAction(
          label: 'Grant',
          onPressed: () async {
            // Open the app settings to allow the user to grant permission.
            await openAppSettings();
          },
        ),
      ));
    }
  } else {
    // Permission already granted, continue with location-based tasks.
  }
}

NotifyHelper api=NotifyHelper();
Future onBackground(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification.toString());
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.instance;
  LocalNotificationService.initialize();
  FirebaseMessaging.onBackgroundMessage(onBackground);
  await CacheHelper.init();
 await api.initializeNotification();
  //await api.showNotification(id: 1,body: "hi",image:"https://tse1.mm.bing.net/th?id=OIP.M9AsZ7Sm6Qq-LXpY92Tt2AHaEK&pid=Api&P=0");
  onBoarding = await CacheHelper.getData(key: 'onBoarding');
  asGuest = await CacheHelper.getData(key: 'asGuest');
  token = await CacheHelper.getData(key: 'token');


  print("token is $token");


  runApp(const MyApp(startWidget: SplashScreen()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.startWidget}) : super(key: key);
  final Widget startWidget;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => AppCubit()
              ..getUserData()
              ..getAllPlaces()
              ..getTopRatedPlaces()
              ..getTourGuides()
                ..getCountries()
                ..getPlans()
        )
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.purple,
            ),
            routes: {
              'login': (context) => login(),
              'registerregister': (context) => register(),
              'profile': (context) => Profile(),
              'editprofile': (context) => editProfile(),
              'welcomescreen': (context) => const WelcomePage(),
              'mainhome': (context) => mainScreens(),
              'forgetpassword': (context) => forgetPassword()
            },
           // home: startWidget,
            home: DeleteMe(),
            debugShowCheckedModeBanner: false,
          );
        },
        listener: (context, state) {},
      ),
    );
  }
}

// await WidgetsFlutterBinding.ensureInitialized();
// await NotificationService().initNotification();
// NotificationService()
//     .showNotification(title: 'Sample title', body: 'It works!');

// NotifyHelper api=NotifyHelper();
//  api.initializeNotification();
//  api.showScheduledNotification(body: "i'm ahmed", scheduledDate: DateTime.now().add(const Duration(seconds: 15)));

// getCountries();
// double usdAmount = 90.0;
// double egpAmount = await convertCurrency(usdAmount);
// print('$usdAmount USD is $egpAmount EGP');

// const phoneNumber = '+201003465232'; // Replace with the phone number you want to send a message to
// const url = 'whatsapp://send?phone=$phoneNumber';
//
// if (await canLaunchUrl (Uri.parse(url))
// ) {
//   await launchUrl(Uri.parse(url));
// } else {
//   throw 'Could not launch $url';
// }


/*
import 'package:geocoding/geocoding.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
// very important
Future<void> _searchPlace(String placeName) async {

  await GeocodingPlatform.instance.locationFromAddress(placeName)
      .then((value) async
  {
    print("success");
    print(value.first.latitude);
    print(value.first.longitude);
    if (value.isNotEmpty) {
      print( await getPlaceId(value.first.latitude, value.first.longitude));
  }
  })
  .catchError((error)
  {
    print("error 66666666666");
    print(error.toString());
  });
}

Future<String> getPlaceId(double latitude, double longitude) async {
  print("object");
  const apiKey = "AIzaSyBWB1JR4gnnhypAmwDFckN0anoRUTH5SAY";
  final url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&key=$apiKey";
  await http.get(Uri.parse(url))
      .then((value)
      {
        print("&&&&&&&&&&&&");
        print(value.body.toString());
        final json = jsonDecode(value.body);
        final results = json["results"] as List<dynamic>;
        print(results.length);
        if (results.isNotEmpty) {
          final firstResult = results.first as Map<String, dynamic>;
          final placeId = firstResult["place_id"] as String;
          print("/////////////");
          print(placeId);
          return "${placeId?? "null"}  0000000000000000000000000000000000000";
        }
      })
      .catchError((error)
      {
        print("%%%%%%%%%%%%");
        print(error.toString());
      });
  return "empty";
}

 */