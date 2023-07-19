import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:firebase_core/firebase_core.dart';

// final Firebase firebase = ;

_launchGoogleMapsURL() async {
  const url =
      'https://www.google.com/maps/place/The+Great+Pyramid+of+Giza/@29.9792345,31.131627,17z/data=!3m1!4b1!4m6!3m5!1s0x14584587ac8f291b:0x810c2f3fa2a52424!8m2!3d29.9792345!4d31.1342019!16zL20vMDM2bWs';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class myMap extends StatelessWidget {
  const myMap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: mapScreen(),
    );
  }
}

class mapScreen extends StatefulWidget {
  const mapScreen({Key? key}) : super(key: key);

  @override
  State<mapScreen> createState() => _mapScreenState();
}

class _mapScreenState extends State<mapScreen> {
  double _rating = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MAP TEST"),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: [
          Stack(children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              child: Image.asset("assets/pyramids.jpg"),
            ),
            Positioned(
              top: 20,
              right: 15,
              child: IconButton(
                icon: Icon(
                  Icons.favorite,
                  color: Colors.purple,
                  size: 40,
                ),
                onPressed: () {},
              ),
            ),
          ]),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                width: 400,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(children: [
                    Row(
                      children: [
                        Column(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Pyramids",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Row(children: [
                                RatingBar.builder(
                                  initialRating: 3,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 3),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {
                                    setState(() {
                                      _rating = rating;
                                    });
                                  },
                                  itemSize: 25,
                                ),
                                Text("$_rating"),
                              ]),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.purple),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                            ),
                            child: Text("Book now"),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                          "The Egyptian pyramids are ancient masonry structures located in Egypt. Sources cite at least 118 identified Egyptian pyramids. Approximately 80 pyramids were built within the Kingdom of Kush, now located in the modern country of Sudan. Of those located in modern Egypt, most were built as tombs for the country's pharaohs and their consorts during the Old and Middle Kingdom periods"),
                    ),
                    GestureDetector(
                      onTap: _launchGoogleMapsURL,
                      child: Expanded(
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Stack(children: [
                              Image.asset(
                                "assets/map.jpeg",
                                height: 200,
                                width: 300,
                              ),
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: IconButton(
                                    icon: Icon(Icons.location_on),
                                    iconSize: 50,
                                    color: Colors.purple,
                                    onPressed: _launchGoogleMapsURL,
                                  ),
                                ),
                              ),
                              Positioned.fill(
                                child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                        "assets/googlemap.png",
                                        height: 30,
                                        width: 30,
                                      ),
                                    )),
                              ),
                            ])),
                      ),
                    )
                  ]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
