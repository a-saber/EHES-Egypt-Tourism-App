import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectt/cubit/cubit.dart';
import 'package:projectt/cubit/state.dart';
import 'package:projectt/models/PlaceModel.dart';

import '../component/defaultrating.dart';

AlertDialog alertRate(PlaceModel placeModel) => AlertDialog(
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
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  width: width * 0.31,
                  height: height * 0.31,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'What do you think of this place ?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const DefaultRating(rate: 0.0, readOnly: false),
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
                                  if (AppCubit.get(context).newRateValue != null) {
                                    placeModel.raters = placeModel.raters! + 1;
                                    placeModel.rateValue = placeModel.rateValue! + AppCubit.get(context).newRateValue!;
                                    placeModel.rate = placeModel.rateValue! / placeModel.raters!;
                                    AppCubit.get(context).updatePlaceRate(placeModel);
                                  }
                                },
                                child: const Text("Done",
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
                );
              },
              listener: (context, state) {});
        },
      ),
    );
