import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectt/component/defaultbutton.dart';
import 'package:projectt/cubit/cubit.dart';
import 'package:projectt/cubit/state.dart';
import 'package:projectt/screens/profile/editProfile.dart';
import 'package:projectt/screens/favourite.dart';
import '../endpoint.dart';
import '../guest_ask_for_auth.dart';
import '../MyPlan.dart';
import '../Setting.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

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
          return AppCubit
              .get(context)
              .userModel != null
              ? Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: const Text(
                  "Profile",
                  style: TextStyle(color: Colors.black),
                ),
                centerTitle: true,
                backgroundColor: Colors.white,
                elevation: 0,
              ),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 5),
                    child: Container(
                      width: double.infinity,
                      height: 290,
                      child: Card(
                        elevation: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: Column(
                            children: [
                              Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        '${AppCubit
                                            .get(context)
                                            .userModel!
                                            .image}',
                                      ),
                                      fit: BoxFit.cover,
                                    )),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text("${AppCubit
                                  .get(context)
                                  .userModel!
                                  .name}"),
                              SizedBox(
                                height: 10,
                              ),
                              Text("${AppCubit
                                  .get(context)
                                  .userModel!
                                  .email}"),
                              SizedBox(
                                height: 10,
                              ),
                              defaultButton(
                                  text: "Edit",
                                  color: Colors.purple,
                                  onpressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                editProfile()));
                                  })
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      child: ListView(children: [
                        buildListTile(Icons.settings, "Setting", () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Setting()));
                        }),
                        buildListTile(Icons.map, "My Plan", () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Myplan()));
                        }),
                        buildListTile(Icons.favorite, "Favorite", () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Favourite()));
                        }),
                        buildListTile(Icons.logout, "Logout", () {
                          AppCubit.get(context).logout(context);
                        })
                      ]))
                ],
              ))
              : const Center(
                 child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Padding buildListTile(IconData icons, String text, Function() function) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: InkWell(
        onTap: function,
        child: Card(
          elevation: 5,
          child: ListTile(
            leading: Icon(icons),
            title: Text(text),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
        ),
      ),
    );
  }
}
