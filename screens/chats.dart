import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectt/cubit/cubit.dart';
import 'package:projectt/cubit/state.dart';
import 'package:projectt/models/Tourguide.dart';
import 'package:projectt/screens/endpoint.dart';
import 'package:projectt/screens/presentation/chat_detils_screen.dart';
import 'package:projectt/screens/profile/editProfile.dart';
import 'package:projectt/screens/search_chat.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/Users.dart';
import '../models/message_model.dart';
import '../network/fcn_notification.dart';

class Chats extends StatefulWidget {
  const Chats({Key? key}) : super(key: key);

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((message) {
      LocalNotificationService.display(message);
    });
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return  SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Container(
                        padding: const EdgeInsets.only(left: 20, top: 10),
                        width: double.infinity,
                        height: 230,
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.3),
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(35.0),
                                bottomRight: Radius.circular(35.0))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Messages",
                                style: TextStyle(
                                    color: Colors.purple,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20)),
                            const SizedBox(height: 10,),
                            Row(

                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.grey.withOpacity(0.5),
                                  radius: 30,
                                  child: Align(
                                    alignment: Alignment.center,
                                      child: IconButton(onPressed: (){}, icon: const Icon(Icons.add,color: Colors.white,size: 30,))),
                                ),
                                const SizedBox(width: 15,),
                                Expanded(
                                  child: SizedBox(
                                    height: 100,
                                    child: ListView.separated(
                                      physics: const BouncingScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) => CircleAvatar(
                                          backgroundImage: NetworkImage("${AppCubit.get(context).tourGuides[index].image}"),
                                          radius: 30,
                                        ),
                                        separatorBuilder: (context, index) =>
                                            const SizedBox(
                                              width: 15,
                                            ),
                                        itemCount: AppCubit.get(context).tourGuides.length),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            InkWell(
                              onTap: ()
                              {
                                AppCubit.get(context).getChats().then((event)
                                {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                          const SearchChat()));
                                });
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
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("users")
                              .doc(token)
                              .collection("chats")
                              .orderBy("dateTime", descending: true)
                              .snapshots(),
                          builder: (BuildContext context, snapshot) {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }
                            if (!snapshot.hasData) {
                              return const Text('');
                            }

                            AppCubit.get(context).chats = snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                              Users user = Users(uid: document.id);
                              user.lastMessage = MessageModel.fromJson(
                                  document.data() as Map<String, dynamic>);
                              return user;
                            }).toList();

                            return ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return buildContainer(
                                    AppCubit.get(context).chats[index], context);
                              },
                              itemCount: AppCubit.get(context).chats.length,
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Divider(),
                                );
                              },
                            );
                          }),
                    ),
                  ],
                ),
              ),
            );
      },
    );
  }

  Widget buildContainer(Users userWithLast, context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userWithLast.uid)
            .snapshots(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData) {
            return const Text('');
          }
          Users user =
              Users.fromJson(snapshot.data!.data() as Map<String, dynamic>);
          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatDetailsScreen(
                            model: user,
                          )));
            },
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundImage: NetworkImage("${user.image}"),
                radius: 30,
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(user.name!,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Text(
                    userWithLast.lastMessage!.dateTime!.substring(11, 16),
                    style: const TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              subtitle: Row(
                children: [
                  Text(
                      userWithLast.lastMessage!.senderId == token
                          ? "me : "
                          : "friend : ",
                      style: const TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold)),
                  Text(
                    userWithLast.lastMessage!.text!,
                    style: const TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
