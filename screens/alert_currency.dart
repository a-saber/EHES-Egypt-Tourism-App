import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectt/component/defaulttextformfield.dart';
import 'package:projectt/cubit/cubit.dart';
import 'package:projectt/cubit/state.dart';
import 'package:projectt/models/PlaceModel.dart';
import 'package:projectt/models/currency_country_model.dart';

import '../component/defaultrating.dart';

AlertDialog alertCurrency(CountryCurrencyModel model) {
  return AlertDialog(
    insetPadding: EdgeInsets.zero,
    contentPadding: EdgeInsets.zero,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30.0))),
    content: Builder(
      builder: (context) {
        // Get available height and width of the build area of this widget. Make a choice depending on the size.
        var height = MediaQuery
            .of(context)
            .size
            .height;
        var width = MediaQuery
            .of(context)
            .size
            .width;

        return BlocConsumer<AppCubit, AppStates>(
            builder: (context, state) {
             // AppCubit.get(context).moneyController.text="";
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.symmetric(
                    vertical: 20, horizontal: 20),
                width: width * 0.31,
                height: height * 0.35,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Row(
                           children: [
                              const Text(
                               'From : ',
                              // textAlign: TextAlign.start,
                               style: TextStyle(
                                 fontSize: 20,
                                 color: Colors.grey,
                                 fontWeight: FontWeight.bold,
                               ),
                              ),
                             Expanded(
                               child: Text(
                                '${model.countryName}',
                                 maxLines: 1,
                                 overflow: TextOverflow.ellipsis,
                                 textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                               ),
                             ),
                           ],
                         ),
                         const SizedBox(height: 10,),
                         Row(
                           children: const
                           [
                              Text(
                              'To      : ',
                              textAlign: TextAlign.start,
                              style:  TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                             ),
                             Expanded(
                               child: Text(
                                ' EGP',
                                textAlign: TextAlign.center,
                                style:  TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                               ),
                             ),
                           ],
                         ),
                       ],
                     ),
                    Column(
                      children:
                      [
                        SizedBox(
                          height: 50,
                          child: defaultTextFormField(text: "Money",
                              controller: AppCubit.get(context).moneyController,
                              textInputType: TextInputType.number,
                              obsuretext: false,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Please enter Money Number";
                                }
                                return null;
                              }),
                        ),
                        const SizedBox(height: 10,),
                        Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.purple
                          ),
                          child: Center(
                            child: state is ConvertCurrenciesLoadingState?
                            const SizedBox(
                              height: 25,width: 25,
                                child:   CircularProgressIndicator(color: Colors.white)):
                            Text(
                                AppCubit.get(context).convertedAmount == null?
                                    "":
                              state is ConvertCurrenciesSuccessState?
                              "${AppCubit.get(context).convertedAmount!.toStringAsFixed(2)}  EGP"
                                  :
                                  "",
                              style: const TextStyle(color:Colors.white, fontWeight: FontWeight.bold),),
                          ),
                        ),
                      ],
                    ),
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
                              onPressed: () {
                                if( state is ConvertCurrenciesLoadingState == false) {
                                  if (AppCubit
                                      .get(context)
                                      .moneyController
                                      .text
                                      .isNotEmpty) {
                                    AppCubit.get(context).convertCurrency(
                                        AppCubit
                                            .get(context)
                                            .moneyController
                                            .text, model.countryCode!);
                                  }
                                }
                              },
                              child: const Text("Convert",
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

}
