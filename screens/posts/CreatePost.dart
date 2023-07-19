import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectt/cubit/cubit.dart';
import 'package:projectt/cubit/state.dart';

class CreatePost extends StatefulWidget {
  CreatePost({Key? key}) : super(key: key);

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  @override
  void initState() {
    AppCubit.get(context).postImage = null;
    super.initState();
  }
  TextEditingController textcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state)
      {
        if( state is createPostSucessState) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        var cubit = AppCubit
            .get(context);
        return cubit.userModel!=null? Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(elevation: 0,
            backgroundColor: Colors.white,
            title: const Text(
              "Create post", style: TextStyle(color: Colors.black),),
            actions: [TextButton(onPressed: () {
              var now=DateTime.now();
              if(cubit.postImage==null){
                cubit.createPost(text: textcontroller.text, datetime: now.toString());
              }else{
                cubit.uploadPostImage(dateTime: now.toString(), text: textcontroller.text);
              }
            }, child: Text("Post"))],),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: Column(
              children: [

                if(state is createPostLoadingState)
                  Column(
                    children: const
                    [
                       LinearProgressIndicator(),
                      SizedBox(height: 20,)
                    ],
                  ),
                Row(
                    children: [
                      CircleAvatar(radius: 22,
                        backgroundImage: NetworkImage(
                            '${cubit.userModel?.image}'),
                      ),

                      SizedBox(width: 15,),
                      Text("${cubit.userModel?.name}",
                        style: TextStyle(color: Colors.black, fontSize: 20),),
                    ]),
                SizedBox(height: 5,),
                TextFormField(
                  controller: textcontroller,
                  keyboardType: TextInputType.text,
                  minLines: 1,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "What is in your mind",
                    border: InputBorder.none,

                  ),
                ),
                if(cubit.postImage!=null)
                  Expanded(child:Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 250,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            image: DecorationImage(
                                image: FileImage(File(AppCubit.get(context).postImage!.path)),fit: BoxFit.cover
                            )
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.blue,
                          child: IconButton(
                            onPressed: (){
                              cubit.removePostImage();
                            },
                            icon: Icon(Icons.close,color: Colors.white,),
                          ),
                        ),
                      )
                    ],
                  ) ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(onPressed: () {
                        AppCubit.get(context).getPostImage();
                      }, child: Row(children: [
                        Icon(Icons.image),
                        SizedBox(width: 5,),
                        Text("add photo")
                      ],))
                    ],),
                )
              ],
            ),
          ),

        ):Center(child: CircularProgressIndicator(),);

      },

    );
  }
}

