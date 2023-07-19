import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectt/component/default_time_picker.dart';
import 'package:projectt/cubit/cubit.dart';
import 'package:projectt/cubit/state.dart';
import 'package:projectt/models/PlaceModel.dart';

import '../component/defaultrating.dart';
import '../models/plan_model.dart';

AlertDialog alertPlanTime(PlanModel plan, PlaceModel place) => AlertDialog(
  insetPadding: EdgeInsets.zero,
  contentPadding: EdgeInsets.zero,
  shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(30.0))),
  content: Builder(
    builder: (context) {
      // Get available height and width of the build area of this widget. Make a choice depending on the size.
      var height = MediaQuery.of(context).size.height;
      var width = MediaQuery.of(context).size.width;

      return BlocConsumer<AppCubit, AppStates>(
          builder: (context, state)
          {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              width: width * 0.31,
              height: height * 0.31,
              child: Column(
                children: [
                  state is bookLoadingState ?
                  Container(
                      padding: const EdgeInsets.only(top: 5, left: 20,right: 20),
                      child: const LinearProgressIndicator()
                  ):
                  const SizedBox(height: 10,),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20, top: 10),

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Pick Date',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.purple,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const DefaultDatePicker(label: "Date"),
                          const DefaultTimerPicker(label: "Time"),
                          state is PlaceUpdateLoadingState ?
                          const Center(child: CircularProgressIndicator())
                              :
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.purple,
                                  ),
                                  child: MaterialButton(
                                    onPressed: ()
                                    {
                                      if(date != null && time != null) {
                                        plan.date = date;
                                        plan.time = time;
                                        AppCubit.get(context).addToPlan(plan,place, context);
                                      }
                                    },
                                    child: const Text("Confirm",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.purple,
                                  ),
                                  child: MaterialButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      "Cancel",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          listener: (context, state) {});
    },
  ),
);
