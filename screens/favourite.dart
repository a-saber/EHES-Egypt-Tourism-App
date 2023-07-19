import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectt/cubit/cubit.dart';
import 'package:projectt/cubit/state.dart';
import 'package:projectt/models/PlaceModel.dart';
import 'package:projectt/screens/guest_ask_for_auth.dart';
import 'package:projectt/screens/places_lists/place_details.dart';

import 'endpoint.dart';

class Favourite extends StatelessWidget {
  const Favourite({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        if (asGuest != null)
        {
          return const GuestASkForAuth();
        }
        else {
          var cubit = AppCubit.get(context);
          return cubit.favouritePlaces.isNotEmpty
              ? Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: const Text(
                  "Favourite",
                  style: TextStyle(color: Colors.black),
                ),
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
                          return buildStack(
                              cubit.favouritePlaces[index], context, index);
                        },
                        itemCount: cubit.favouritePlaces.length,
                      ),
                    ),
                  ],
                ),
              ))
              : const Center(
                child: Text("You don't have any favourite Places"),
          );
        }
      }
    );
  }

  Widget buildStack(PlaceModel placemodel, context, int index) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PlaceDetails(place: placemodel)));
      },
      child: Container(
        height: 150,
        width: double.infinity,
        child: Card(
          elevation: 4,
          child: Row(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image(
                    image: NetworkImage("${placemodel.image}"),
                    fit: BoxFit.cover,
                    height: 125,
                    width: 120,
                  )),
              const SizedBox(width: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${placemodel.name}",
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    width: 140,
                    child: Text(
                      "${placemodel.description}",
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                      maxLines: 4,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                  onPressed: () async {
                    AppCubit.get(context).deleteFromFavourite(context: context, placeId: placemodel.id!, index: index);
                  },
                  icon: const Icon(Icons.delete_outline_outlined))
            ],
          ),
        ),
      ),
    );
  }
}
