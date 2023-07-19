import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectt/cubit/cubit.dart';
import 'package:projectt/cubit/state.dart';
import 'package:projectt/models/currency_country_model.dart';
import 'package:projectt/screens/alert_currency.dart';
import 'package:projectt/screens/search_currencies.dart';

class CountryCurrencyScreen extends StatelessWidget {
  const CountryCurrencyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        builder: (context, state)
        {
          return SafeArea(
              child:
              Column(
                children: [
                  Container(
                      padding: const EdgeInsets.only(left: 20, top: 10),
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(35.0),
                              bottomRight: Radius.circular(35.0))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Currencies",
                              style: TextStyle(
                                  color: Colors.purple,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20)),
                          const SizedBox(height: 10,),

                          InkWell(
                            onTap: ()
                            {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                        const SearchCurrencies()));
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 20,bottom: 20),
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Row(
                                  children:
                                  [
                                    Icon(Icons.search,color:Colors.grey.withOpacity(0.5) ,),
                                    const SizedBox(width: 10,),
                                    Text("Search",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.grey.withOpacity(0.5)),)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),

                  state is GetCountriesCurrenciesLoadingState
                      ?
                  const Center(child: CircularProgressIndicator(),)
                      :
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ListView.builder(
                        itemBuilder: (context, index)=>
                            CountryCurrencyItem(
                                model: AppCubit.get(context).countriesCurrencies[index]
                            ),
                        itemCount: AppCubit.get(context).countriesCurrencies.length,
                       // shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                      ),
                    ),
                  ),
                ],
              ),
            );

        },
        listener: (context, state) {}
    );
  }
}

class CountryCurrencyItem extends StatelessWidget {
  const CountryCurrencyItem({Key? key, required this.model}) : super(key: key);
  final CountryCurrencyModel model;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: InkWell(
        onTap: (){
          AppCubit.get(context).moneyController.text = "";
          AppCubit.get(context).convertedAmount = null;
          showDialog(
            context: context,
            builder: (BuildContext ctx) =>
                alertCurrency(model),
            barrierDismissible: false,
          );
        },
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              //   color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10)
            ),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(model.countryName!,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ),
    );
  }
}

