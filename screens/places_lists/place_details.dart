
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectt/cubit/cubit.dart';
import 'package:projectt/cubit/state.dart';
import 'package:projectt/main.dart';
import 'package:projectt/models/PlaceModel.dart';
import 'package:projectt/models/plan_model.dart';
import 'package:projectt/screens/alert_plan_time.dart';
import 'package:projectt/screens/maps/search_map.dart';
import 'package:projectt/screens/maps/suggest.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../component/defaultbutton.dart';
import '../../component/defaultrating.dart';
import '../Booking.dart';
import '../alert_rate.dart';
import '../endpoint.dart';
import '../guest_ask_for_auth.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;

class PlaceDetails extends StatelessWidget {
  final PlaceModel place;
  const PlaceDetails({Key? key, required this.place}) : super(key: key);
  _launchGoogleMapsURL({required String link}) async {
    const urlPlace = 'https://www.google.com/maps/place/The+Great+Pyramid+of+Giza/@29.9792345,31.131627,17z/data=!3m1!4b1!4m6!3m5!1s0x14584587ac8f291b:0x810c2f3fa2a52424!8m2!3d29.9792345!4d31.1342019!16zL20vMDM2bWs';
    const urlSuggest = 'https://www.google.com/maps/search/%D8%A7%D9%85%D8%A7%D9%83%D9%86+%D8%B3%D9%8A%D8%A7%D8%AD%D9%8A%D8%A9+%D8%A8%D8%AC%D8%A7%D9%86%D8%A8+%D8%B4%D8%A7%D8%B1%D8%B9+%D8%A7%D9%84%D9%85%D8%B9%D8%B2+%D9%84%D8%AF%D9%8A%D9%86+%D8%A7%D9%84%D9%84%D9%87+%D8%A7%D9%84%D9%81%D8%A7%D8%B7%D9%85%D9%8A%E2%80%AD%E2%80%AD/@30.1312521,32.144024,9z/data=!3m1!4b1?authuser=0';
    if (await canLaunch(link)) {
      await launch(link);
    } else {
      throw 'Could not launch $link';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state)
        {
          if (state is PlaceUpdateSuccessState||state is bookSucessState)
            {
              Navigator.pop(context);
            }
        },
        builder: (context, state)
        {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40)),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(40),
                          bottomLeft: Radius.circular(40)),
                      child: Image(
                        image: NetworkImage("${place.image}"),
                        fit: BoxFit.cover,
                        height: 330,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              place.name!,
                              style:const TextStyle(
                                  fontSize: 25,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            const  Spacer(),
                            IconButton(
                                onPressed: () {
                                  if (asGuest != null )
                                  {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            const GuestASkForAuth()));
                                  }
                                  else {
                                    if (AppCubit.get(context).favouritePlacesId.contains(place.id))
                                    {
                                      AppCubit.get(context).deleteFromFavourite(
                                          context: context,
                                          placeId: place.id!
                                      );
                                    }
                                    else {
                                      print(place.name);
                                      AppCubit.get(context).addToFavourite(
                                          context,
                                          place.id!
                                      );
                                    }
                                  }
                                },
                                icon: Icon(
                                    asGuest != null ?
                                    Icons.favorite_outline :
                                  AppCubit.get(context).favouritePlacesId.contains(place.id) ?
                                      Icons.favorite :
                                      Icons.favorite_outline,
                                  color: Colors.purple,))
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: ()async
                                {
                                 // await checkLocationPermission(context);

                                print("Location");
                                _launchGoogleMapsURL(link: place.mapLink!);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      color: Colors.purple,
                                      size: 22,
                                    ),
                                    const  SizedBox(
                                      width: 8,
                                    ),
                                     Text(place.location!,
                                        style :const TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold
                                        )),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10,),
                            Expanded(
                              child: InkWell(
                                onTap: ()async
                                {
                                 // await checkLocationPermission(context);

                                print("Location");
                                _launchGoogleMapsURL(link: place.nearbyLink!,);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.purple,
                                      size: 22,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                     Text("Nearby",
                                        style :TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey,
                                            fontWeight: FontWeight.bold

                                        )),
                                  ],
                                ),
                              ),
                            ),

                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: ()
                              {
                                if (asGuest != null )
                                {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                          const GuestASkForAuth()));
                                }
                                else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext ctx) =>
                                        alertRate(place),
                                    barrierDismissible: false,
                                  );
                                }
                              },
                                child: DefaultRating(rate: place.rate! )),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "(${place.raters}) ",
                              style:const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Description",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          place.description!,
                          style: const TextStyle(
                              fontSize: 15, color: Colors.grey, height: 1.3),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0,right: 20,top: 20,bottom: 10),
                    child: Row(
                      children: [
                        Expanded(
                            child:  SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (asGuest != null )
                                  {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            const GuestASkForAuth()));
                                  }
                                  else {
                                    AppCubit.get(context).sendMessageWhatsApp(place);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple,
                                ),
                                child: const Text("Book", style: TextStyle(fontWeight: FontWeight.bold),),
                              ),
                            )
                        ),
                        const SizedBox(width: 10,),

                        Expanded(
                          child:  SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                if (asGuest != null )
                                {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                          const GuestASkForAuth()));
                                }
                                else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext ctx) =>
                                        alertPlanTime(
                                            PlanModel(status: "new", placeId: place.id, date: DateTime.now().toString(), time: DateTime.now().toString()),
                                          place
                                        ),
                                    barrierDismissible: false,
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple,
                                  ),
                              child: const Text("Add To Plans", style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          )
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Material(
                      borderRadius:  BorderRadius.circular(10),
                      elevation: 5,
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        decoration:  BoxDecoration(
                          color: Colors.purple,
                          borderRadius:  BorderRadius.circular(10),
                          image: const DecorationImage(
                              image: AssetImage("images/map.jpeg"),
                            fit: BoxFit.fill
                          )
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }
    );
  }
}
