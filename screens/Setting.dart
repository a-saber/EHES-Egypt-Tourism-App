import 'package:flutter/material.dart';
import 'package:projectt/screens/PrivacyPolicy.dart';
import 'package:projectt/screens/about.dart';
import 'package:projectt/screens/emergencynumbers.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:share_plus/share_plus.dart';
import 'package:store_redirect/store_redirect.dart';

import 'Help.dart';

class Setting extends StatelessWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            "Setting",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
        ),
        body: ListView(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          children: [
            buildCard(Icons.share, "Share", () {
              Share.share(
                  "https://play.google.com/store/apps/details?id=com.instructivetech.testapp");
            }),
            buildCard(Icons.privacy_tip, "Privacy Policy", () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>PrivacyPolicy()));
            }),
            buildCard(Icons.star_rate, "Rate this app", () {}),
            buildCard(Icons.info, "About us", () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => About()));
            }),
            buildCard(Icons.help, "Help", () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Helpp()));
            }),
            buildCard(Icons.warning, "Emergency Numbers", () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EmergencyNumbers()));
            }),
          ],
        ));
  }

  Padding buildCard(IconData iconData, String text, Function() function) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: Card(
        elevation: 5,
        child: ListTile(
          onTap: function,
          leading: Icon(iconData),
          title: Text(text),
        ),
      ),
    );
  }
}
