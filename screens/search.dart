import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectt/cubit/cubit.dart';
import 'package:projectt/cubit/state.dart';
import 'package:projectt/models/PlaceModel.dart';
import 'package:projectt/screens/places_lists/place_details.dart';

import '../component/defaultrating.dart';
import '../component/defaulttextformfield.dart';

class Search extends StatelessWidget {
  const Search({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController searchcontroller = TextEditingController();
    final formKey = GlobalKey<FormState>();
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
            return Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  title: Text("Search",style: TextStyle(color: Colors.black),),
                  leading: IconButton(
                      onPressed: ()
                      {
                        Navigator.pop(context);
                      }, icon: Icon(Icons.arrow_back,color: Colors.purple,)),
                ),
                body: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "where do ",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "you want to go?",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: defaultTextFormField(
                                    onChange: (value)
                                    {
                                      AppCubit.get(context).search(searchcontroller.text);
                                    },
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Please enter text that you want search about it";
                                      }
                                      return null;
                                    },
                                    obsuretext: false,
                                    textInputType: TextInputType.text,
                                    text: "search for places...",
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
                                        AppCubit.get(context).search(searchcontroller.text);
                                      }
                                    },
                                  ),
                                )
                              ],
                            ),
                            if (state is getSearchedPlacesLoadingState)
                              const Padding(
                                padding:  EdgeInsets.only(top: 10.0),
                                child:  Center(child: CircularProgressIndicator(),),
                              ),
                            const SizedBox(height: 20,),
                            if(state is getSearchedPlacesSucessState && searchcontroller.text.isNotEmpty)
                            ListView.builder(
                              scrollDirection: Axis.vertical,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return buildContainer(AppCubit.get(context).placesSearch[index], context);
                              },
                              itemCount: AppCubit.get(context).placesSearch.length,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ));
      },
    );
  }

  Widget buildContainer(PlaceModel place, context) {
    String name =StringUtils.capitalize(place.name!);
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>PlaceDetails(place: place)));
      },
      child: Padding(
          padding: const EdgeInsets.all(5.0),
          child:SizedBox(height: 150,width: double.infinity,
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
                        Text(name,style: const TextStyle(fontSize: 23,fontWeight: FontWeight.w500),),
                        Text("${place.location}",style: TextStyle(color: Colors.grey),),
                        DefaultRating(rate : place.rate! ),
                        Text("${place.raters} out of five",style: TextStyle(color: Colors.grey),),


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
