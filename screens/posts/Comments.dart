import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectt/cubit/cubit.dart';
import 'package:projectt/cubit/state.dart';
import 'package:projectt/models/PostModel.dart';
import 'package:projectt/models/comments.dart';

import '../../models/Users.dart';
import '../endpoint.dart';
import '../profile/editProfile.dart';

class Comments extends StatelessWidget {
  int postIndex;


  Comments({Key? key,  required this.postIndex})
      : super(key: key);
  TextEditingController commentcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: [
                Expanded(
                  child:
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                .doc(AppCubit.get(context).homePosts[postIndex].postId)
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

              AppCubit.get(context).homePosts[postIndex].comments=[];
              AppCubit.get(context).homePosts[postIndex].comments =
                  snapshot.data!.docs
                      .map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                    return Commentmodel.fromjson(data);
                  }).toList();
              print("${AppCubit.get(context).homePosts[postIndex].comments.length}   ////////////////");

              return ListView.separated(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 13),
                      child:
                      buildColumn(
                          commentModel: AppCubit.get(context).homePosts[postIndex].comments[index],
                          context: context
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                  itemCount:  AppCubit.get(context).homePosts[postIndex].comments.length);
            }),
                ),
                if (asGuest == null )
                  buildPadding(context)
              ],
            ));
      },
    );
  }

  Padding buildPadding(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextFormField(
        controller: commentcontroller,
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 13, color: Colors.black),
        decoration: InputDecoration(
            hintText: "write a comment.....",
            filled: true,
            fillColor: Colors.grey.shade200,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
            suffixIcon: IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                AppCubit.get(context).createComment(
                    commentcontroller.text,
                    DateTime.now().toString(),
                    AppCubit.get(context).homePosts[postIndex].postId.toString(),
                    postIndex);
              },
            )),
      ),
    );
  }

  Padding buildColumn({ required Commentmodel commentModel,required context}) {
    print("${commentModel.uId}  ***************");
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(commentModel.uId)
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
                commentModel.user =
                    Users.fromJson(data);
                return Row(
                  children: [
                    InkWell(
                      onTap:()
                      {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    editProfile(friend: commentModel.user,)));
                      },
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            commentModel.user!.image!
                        ),
                        radius: 22,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey.shade200,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                commentModel.user!.name!,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("${commentModel.text}",
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 5)
                          ],
                        ),
                      ),
                    )
                  ],
                );
              }),
        ],
      ),
    );
  }
}
