import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectt/cubit/cubit.dart';
import 'package:projectt/cubit/state.dart';
import 'package:projectt/models/Tourguide.dart';
import 'package:projectt/screens/profile/editProfile.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/Users.dart';
class TourGuide extends StatelessWidget {
   const TourGuide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context,state){
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text("Tour Guides available: ",style: TextStyle(color: Colors.black),
            ),
            elevation: 0,
            backgroundColor: Colors.white,
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context,index){
                    return buildContainer(AppCubit.get(context).tourGuides[index], context);
                  },
                  itemCount: AppCubit.get(context).tourGuides.length,
                  separatorBuilder: (BuildContext context, int index) {
                  return   const Divider();
                },),
              ),
            ],
          ),

        );
      },

    );
  }

  Widget buildContainer(Users tourGuide, context) {
    return  InkWell(
      onTap: ()
      {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    editProfile(friend: tourGuide,)));
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage("${tourGuide.image}"),
          radius: 30,
        ),
        title: Text(tourGuide.name!, style: const TextStyle(
            fontSize: 20
        )),
        subtitle: Text("${tourGuide.email}"),

      ),
    );
  }
}

