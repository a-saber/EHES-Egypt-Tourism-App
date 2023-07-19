import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectt/component/defaultrating.dart';
import 'package:projectt/cubit/cubit.dart';
import 'package:projectt/cubit/state.dart';
import 'package:projectt/models/PlaceModel.dart';
import 'package:projectt/screens/alert_delete_confirm.dart';
import 'package:projectt/screens/places_lists/place_details.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/plan_model.dart';
import 'endpoint.dart';
import 'guest_ask_for_auth.dart';

class Myplan extends StatelessWidget {
  const Myplan({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state)
      {
        if (state is DeletePlanSuccessState)
          Navigator.pop(context);
      },
      builder: (context, state) {
        if (asGuest != null) {
          return const GuestASkForAuth();
        } else {
          return Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Column(
                    children: [
                      Material(
                        elevation: 10,
                      borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: Colors.purple,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children:  [
                              Expanded(
                                child: InkWell(
                                  onTap: ()
                                  {
                                    AppCubit.get(context).planOnTap(0);
                                  },
                                    child: Text("New",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,

                                            color: AppCubit.get(context).currentPlanIndex ==0 ? Colors.white : Colors.grey.withOpacity(0.5)
                                        ))),
                              ),
                              Expanded(
                                child: InkWell(
                                    onTap: ()
                                    {
                                      AppCubit.get(context).planOnTap(1);
                                    },
                                    child: Text("Done",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: AppCubit.get(context).currentPlanIndex ==1 ? Colors.white : Colors.white.withOpacity(0.5)
                                        ))),
                              ),
                              Expanded(
                                child: InkWell(
                                    onTap: ()
                                    {
                                      AppCubit.get(context).planOnTap(2);
                                    },
                                    child: Text("Archived",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: AppCubit.get(context).currentPlanIndex ==2 ? Colors.white : Colors.white.withOpacity(0.5)
                                        ))),
                              ),

                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      if (AppCubit.get(context).currentPlanIndex ==0)
                      buildList(AppCubit.get(context).newPlans)
                      else if (AppCubit.get(context).currentPlanIndex ==1)
                        buildList(AppCubit.get(context).donePlans)
                      else
                      buildList(AppCubit.get(context).archivedPlans)

                    ],
                  ),
                ),
              ));
        }
      },
    );
  }

  Widget buildList(List<PlanModel> plans) =>
      Expanded(
        child: ListView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
          itemBuilder: (context, index)
          {
            return BuildStack(plan :plans[index], index: index);
          },
          itemCount: plans.length,
        ),
      );
}

class BuildStack extends StatelessWidget {
  const BuildStack({Key? key, required this.plan, required this.index}) : super(key: key);

  final PlanModel plan;
  final int index;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('places')
            .doc(plan.placeId)
            .snapshots(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData) {
            return Text('Loading...');
          }

          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          PlaceModel place = PlaceModel.fromJson(data);
          return InkWell(
            onLongPress: ()
            {
              showDialog(
                context: context,
                builder: (BuildContext ctx) =>
                    alertDeleteConfirm( plan, place.name!),
                barrierDismissible: false,
              );
            },
            onTap: ()
            {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PlaceDetails(place: place)));
            },
            child: SizedBox(
              height: 150,
              width: double.infinity,
              child: Card(
                elevation: 4,
                child: Row(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image(
                          image: NetworkImage(place.image!),
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
                          place.name!,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: 120,
                          child: Text(
                            "${plan.date} \n${plan.time}",
                            style: const TextStyle(color: Colors.grey, fontSize: 13),
                            maxLines: 4,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(onPressed: ()
                    {
                      plan.status = "done";
                      AppCubit.get(context).updatePlan(plan, context);
                    }, icon: const Icon(Icons.done,color: Colors.purple,)),
                    IconButton(onPressed: ()
                    {
                      plan.status = "archived";
                      AppCubit.get(context).updatePlan(plan, context);
                    }, icon: const Icon(Icons.archive_outlined,color: Colors.purple)),

                  ],
                ),
              ),
            ),
          );
        });
  }
}

