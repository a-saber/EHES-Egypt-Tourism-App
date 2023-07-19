import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectt/cubit/cubit.dart';
import 'package:projectt/cubit/state.dart';
import 'package:projectt/models/PostModel.dart';
import 'package:projectt/models/comments.dart';
import 'package:projectt/screens/guest_ask_for_auth.dart';
import '../../models/Users.dart';
import '../endpoint.dart';
import '../profile/editProfile.dart';
import 'Comments.dart';
import 'CreatePost.dart';

class Inquiry extends StatelessWidget {
  const Inquiry({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is getPostLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: const Text(
                "Inquiry about places",
                style: TextStyle(color: Colors.black),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreatePost()));
                    },
                    icon: Icon(
                      Icons.post_add,
                      color: Colors.black,
                    ))
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 10,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Stack(
                        alignment: AlignmentDirectional.bottomEnd,
                        children: const [
                          Image(
                            image: NetworkImage(
                                "https://img.freepik.com/free-photo/photo-delighted-cheerful-afro-american-woman-with-crisp-hair-points-away-shows-blank-space-happy-advertise-item-sale-wears-orange-jumper-demonstrates-where-clothes-shop-situated_273609-26392.jpg?size=626&ext=jpg&uid=R86676578&ga=GA1.2.1191164273.1660582878"),
                            width: double.infinity,
                            height: 250,
                            fit: BoxFit.cover,
                          ),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "communicate with Tourists",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('posts')
                          .orderBy('datetime', descending: true)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        if (!snapshot.hasData) {
                          return const Center(child: Text("Loading ..."),);
                        }
                        AppCubit.get(context).homePosts = snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data() as Map<String, dynamic>;
                          return Postmodel.fromjson(data, document.id);
                        }).toList();

                        return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return buildCard(context, index);
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(
                                height: 7,
                              );
                            },
                            itemCount: AppCubit.get(context).homePosts.length);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Card buildCard(BuildContext context, int index) {
    return Card(
      elevation: 10,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
            child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc("${AppCubit.get(context).homePosts[index].uid}")
                    .snapshots(),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (!snapshot.hasData) {
                    return Text('Loading...');
                  }

                  Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
                  AppCubit.get(context).homePosts[index].user =
                  Users.fromJson(data);
                  return Row(
                    children: [
                      InkWell(
                        onTap: ()
                        {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      editProfile(friend: AppCubit.get(context).homePosts[index].user,)));
                        },
                        child: CircleAvatar(
                            radius: 28,
                            backgroundImage: NetworkImage(
                                AppCubit.get(context).homePosts[index].user!.image!)),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                AppCubit.get(context).homePosts[index].user!.name!,
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    height: 1.4),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Icon(
                                Icons.check_circle,
                                color: Colors.lightBlue,
                                size: 17,
                              )
                            ],
                          ),
                          Text(
                            AppCubit
                                .get(context)
                                .homePosts[index]
                                .datetime!
                                .substring(0, 16),
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                                height: 1.4,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(Icons.more_horiz),
                        onPressed: () {},
                      ),
                    ],
                  );
                }),
          ),
          const Divider(
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Align(
              alignment: AlignmentDirectional.topStart,
              child: Text(
                AppCubit.get(context).homePosts[index].text!,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                style: const TextStyle(fontSize: 20, height: 1.7),
              ),
            ),
          ),
          if (AppCubit.get(context).homePosts[index].postimage != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image(
                    image: NetworkImage(
                        "${AppCubit.get(context).homePosts[index].postimage}"),
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.cover,
                  )),
            ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .doc(AppCubit.get(context).homePosts[index].postId)
                        .collection("likes")
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      if (!snapshot.hasData) {
                        return Container();
                      }
                      AppCubit
                          .get(context)
                          .homePosts[index].likes =
                          snapshot.data!.docs.map((
                              DocumentSnapshot document) {
                            return document.id;
                          }).toList();
                      return InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                asGuest != null ?
                                Icons.favorite_outline:
                                AppCubit
                                    .get(context)
                                    .homePosts[index].likes
                                    .contains(AppCubit
                                    .get(context)
                                    .userModel!
                                    .uid)
                                    ? Icons.favorite
                                    : Icons.favorite_outline,
                                color: Colors.red,
                                size: 16,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                  "${AppCubit
                                      .get(context)
                                      .homePosts[index].likes.length}",
                                  style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                      );
                    }),
              ),
              Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('posts')
                          .doc(AppCubit.get(context).homePosts[index].postId)
                          .collection("comments")
                          .orderBy('datetime', descending: false)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        if (!snapshot.hasData) {
                          return Container();
                        }

                        AppCubit.get(context).homePosts[index].comments =
                            snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data() as Map<String, dynamic>;
                          return Commentmodel.fromjson(data);
                        }).toList();

                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Comments(
                                          postIndex: index,
                                        )));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Icon(
                                  Icons.message,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "${AppCubit.get(context).homePosts[index].comments.length} comment",
                                  style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        );
                      }))
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Divider(
            thickness: 1,
          ),
          SizedBox(
            height: 10,
          ),
          Row(children: [
            Expanded(
                flex: 2,
                child: InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        CircleAvatar(
                            radius: 20,
                            backgroundImage: asGuest != null ? null : NetworkImage(
                                AppCubit.get(context).userModel!.image!),
                            child: asGuest != null ? const Icon(Icons.person) : null),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Comments(
                                              postIndex: index,
                                            )));
                              },
                              child:   Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    "write a comment.....",
                                  style: TextStyle(fontSize: 13, color: Colors.black.withOpacity(0.7)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  if (asGuest != null )
                  {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                               const GuestASkForAuth()));
                  }
                  else{
                    AppCubit.get(context).likepost(index);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(
                        Icons.favorite_outline,
                        color: Colors.red,
                        size: 16,
                      ),
                      Text(
                        "Likes",
                        style: TextStyle(
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.bold,
                            fontSize: 13),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ]),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
