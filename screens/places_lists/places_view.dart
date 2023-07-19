import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectt/models/PlaceModel.dart';
import 'package:projectt/screens/places_lists/place_details.dart';

import '../../component/defaultrating.dart';
import '../../cubit/cubit.dart';
import '../../cubit/state.dart';

class PlacesView extends StatelessWidget {
  final List<PlaceModel> places;
  final String appbarTitle;
  const PlacesView({Key? key, required this.places, required this.appbarTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(appbarTitle ,style: const TextStyle(color: Colors.black),),
              elevation: 0,
              centerTitle: true,
              backgroundColor: Colors.white,
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return buildStack(context, places[index]);
                      },
                      itemCount: places.length,
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  }
  Widget buildStack(context,PlaceModel place) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>PlaceDetails(place: place)));
      },
      child: Padding(
          padding: const EdgeInsets.all(5.0),
          child:Container(height: 150,width: double.infinity,
            child: Card(
              elevation:2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    ClipRRect(borderRadius: BorderRadius.circular(10),child: Image(image:NetworkImage("${place.image}"),fit: BoxFit.cover,height: 125,width: 120,)),
                    const SizedBox(width:20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${place.name}",style:const TextStyle(fontSize: 23,fontWeight: FontWeight.w500),),
                        Text("${place.location}",style:const TextStyle(color: Colors.grey),),
                        DefaultRating(rate: place.rate! ),
                        Text("${place.raters} out of five",style: const TextStyle(color: Colors.grey),),


                      ],
                    )
                  ],
                ),
              ),
            ),
          )
      ),
    );
  }

}
