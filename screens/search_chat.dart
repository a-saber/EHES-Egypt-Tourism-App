import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectt/cubit/cubit.dart';
import 'package:projectt/cubit/state.dart';
import 'package:projectt/models/PlaceModel.dart';
import 'package:projectt/screens/places_lists/place_details.dart';
import 'package:projectt/screens/presentation/chat_detils_screen.dart';

import '../component/defaultrating.dart';
import '../component/defaulttextformfield.dart';
import '../models/Users.dart';

class SearchChat extends StatelessWidget {
  const SearchChat({Key? key}) : super(key: key);

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
              title: const Text("Search",style: TextStyle(color: Colors.black),),
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
                        Row(
                          children: [
                            Expanded(
                              child: defaultTextFormField(
                                onChange: (value)
                                {
                                  AppCubit.get(context).searchFriends(searchcontroller.text);
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Please enter text that you want search about it";
                                  }
                                  return null;
                                },
                                obsuretext: false,
                                textInputType: TextInputType.text,
                                text: "search for friend...",
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
                                    AppCubit.get(context).searchFriends(searchcontroller.text);
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
                        if(state is SearchFriendsSuccessState && searchcontroller.text.isNotEmpty)
                          ListView.separated(
                            scrollDirection: Axis.vertical,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return buildContainer(AppCubit.get(context).searchFriendsList[index], context);
                            },
                            itemCount: AppCubit.get(context).searchFriendsList.length,
                            separatorBuilder: (BuildContext context, int index) =>
                                Container(height: 1,
                                  margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            )
        );
      },
    );
  }

  Widget buildContainer(Users user, context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatDetailsScreen(model: user)));
      },
      child: Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
         //   color: Colors.grey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10)
          ),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundImage: NetworkImage("${user.image}"),
              radius: 30,
            ),
            title: Text(user.name!,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}
