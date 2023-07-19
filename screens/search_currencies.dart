import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../component/defaulttextformfield.dart';
import '../cubit/cubit.dart';
import '../cubit/state.dart';
import '../models/currency_country_model.dart';
import 'alert_currency.dart';

class SearchCurrencies extends StatelessWidget {
  const SearchCurrencies({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController searchcontroller = TextEditingController();
    final formKey = GlobalKey<FormState>();
    return BlocConsumer<AppCubit, AppStates>(
        builder: (context, state)
        {
          return Scaffold(
      backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: const Text("Search",style: TextStyle(color: Colors.black),),
              leading: IconButton(
                  onPressed: ()
                  {
                    Navigator.pop(context);
                  }, icon: Icon(Icons.arrow_back,color: Colors.purple,)),
            ),
            body:  SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: defaultTextFormField(
                              onChange: (value)
                              {
                                AppCubit.get(context).searchCurrencies(searchcontroller.text);
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Please enter text that you want search about it";
                                }
                                return null;
                              },
                              obsuretext: false,
                              textInputType: TextInputType.text,
                              text: "search for Currency...",
                              controller: searchcontroller,
                              iconData: Icons.search,
                              onpress: () {},
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            width: 55,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.purple,
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.filter_alt,
                                color: Colors.white,
                                size: 25,
                              ),
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  AppCubit.get(context).searchCurrencies(searchcontroller.text);
                                }
                              },
                            ),
                          )
                        ],
                      ),
                      if (state is SearchCurrenciesLoadingState)
                        const Padding(
                          padding:  EdgeInsets.only(top: 10.0),
                          child:  Center(child: CircularProgressIndicator(),),
                        ),
                      const SizedBox(height: 20,),
                      if((state is SearchCurrenciesLoadingState == false )&& searchcontroller.text.isNotEmpty)
                        Expanded(
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return CountryCurrencyItem(model :AppCubit.get(context).countriesCurrenciesSearch[index]);
                            },
                            itemCount: AppCubit.get(context).countriesCurrenciesSearch.length,
                            separatorBuilder: (BuildContext context, int index) =>
                                Container(height: 1,
                                  margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        listener: (context, state){}
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

