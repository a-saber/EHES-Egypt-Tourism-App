import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectt/cubit/cubit.dart';
import 'package:projectt/cubit/state.dart';
import 'package:projectt/models/PlaceModel.dart';
import 'package:projectt/screens/Tourguide.dart';
import 'package:projectt/screens/emergencynumbers.dart';
import 'package:projectt/screens/endpoint.dart';
import 'package:projectt/screens/places_lists/place_details.dart';
import 'package:projectt/screens/places_lists/places_view.dart';
import 'package:projectt/screens/search.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/category_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    List<CategoryModel> categories = [
      CategoryModel(text: "Religious Sites", image: "images/old-mosque-cairo-egypt.jpg", screen: PlacesView( places: AppCubit.get(context).religiousPlaces, appbarTitle: "Religious places")),
      CategoryModel(text: "Historical places", image: "images/beautiful-view-plaza-de-espana-seville-spain.jpg", screen: PlacesView( places: AppCubit.get(context).historicalPlaces, appbarTitle: "Historical places")),
      CategoryModel(text: "restaurants&cafes", image: "images/240_F_311286415_BhvuzXaNQhtoxIgWD1p1SRpBro0V4IN5.jpg", screen: PlacesView( places: AppCubit.get(context).touristLandmarks, appbarTitle: "Tourist landmark")),
      CategoryModel(text: "entertainment", image: "images/1000_F_1580390_noPvnJh4R6ZE6yM0FcV0WuHIJyUMO2.jpg", screen:  PlacesView( places: AppCubit.get(context).culturalPlaces, appbarTitle: "Cultural places"))
    ];
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        bool checkGuest = false;
        if( asGuest != null)
        {
          checkGuest =true;
        }
        else
        {
          checkGuest = AppCubit.get(context).userModel != null ;
        }

        return
            checkGuest
            ? Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    leadingWidth: 10,
                    title: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: asGuest != null? null: NetworkImage(
                              "${AppCubit.get(context).userModel!.image}"),
                          backgroundColor: Colors.transparent,
                          child: asGuest != null ? const Icon(Icons.person) : null,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                            asGuest != null ?
                          'Hallo' :
                          "Hallo ... ${AppCubit.get(context).userModel!.name}",
                          style: const TextStyle(color: Colors.black, fontSize: 15),
                        ),
                      ],
                    ),
                    actions: [
                      IconButton(
                          onPressed: ()
                          {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Search()));
                          },
                          icon: const Icon(
                            Icons.search,
                            color: Colors.black,
                          )),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.notifications_active_outlined,
                            color: Colors.black,
                          )),

                    ]),
                body: Padding(
                  padding:  EdgeInsets.only(left: width * 0.05,right: width * 0.05,top: height * 0.015),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Categories",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),

                        CarouselSlider(
                            items: categories
                                .map((e) => buildCarousalItem(context: context, categoryModel: e))
                                .toList(),
                            options: CarouselOptions(
                              height: height * 0.27,
                              initialPage: 0,
                              viewportFraction: 1.0,
                              enableInfiniteScroll: true,
                              reverse: false,
                              autoPlay: true,
                              autoPlayInterval: Duration(seconds: 3),
                              autoPlayAnimationDuration: Duration(seconds: 1),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              scrollDirection: Axis.horizontal,
                            )),

                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Top Rated",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: height * 0.27,
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: AppCubit.get(context).topRated.length,
                            itemBuilder: (BuildContext context, int index) => buildTopRatedItem(context: context, placeModel: AppCubit.get(context).topRated[index]),
                            separatorBuilder: (BuildContext context, int index) =>const SizedBox(width: 2,),

                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Best Services",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            height: height * 0.121,
                            child: ListView(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              children: [
                                buildcontainerservices(
                                    Colors.purple, Icons.warning, () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EmergencyNumbers()));
                                }, "Emergency numbers"),
                                buildcontainerservices(
                                    Colors.purple, Icons.tour, () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TourGuide()));
                                }, "Tour Guide"),
                                buildcontainerservices(
                                    Colors.purple, Icons.cloud, () {
                                  launch(
                                      "https://weather.com/ar-AE/weather/today/l/AEXX0001:1:AE");
                                }, "Wearher"),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  Widget buildCarousalItem({required context, required CategoryModel categoryModel}) {
    return GestureDetector(
      onTap: ()
      {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => categoryModel.screen!));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Container(
          //width: 220,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image(
                  image: AssetImage(categoryModel.image!),
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      categoryModel.text!,
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTopRatedItem({required context, required PlaceModel placeModel}) {
    return GestureDetector(
      onTap: ()
      {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PlaceDetails(place: placeModel)));
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 6.0),
        child: Container(
          width: 220,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image(
                  image: NetworkImage(placeModel.image!),
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      placeModel.name!,
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildcontainerservices(
      Color color, IconData iconData, Function() function, text) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                iconData,
                size: 28,
              ),
              color: Colors.white,
              onPressed: function,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                text,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
