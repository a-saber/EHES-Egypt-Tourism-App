import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectt/cubit/state.dart';

import '../../../../cubit/cubit.dart';
import '../../../models/Users.dart';
import '../chat_detils_screen.dart';

class ChatScreenAddress extends StatelessWidget {
  const ChatScreenAddress({Key? key, required this.model}) : super(key: key);
  final Users model;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatDetailsScreen(
              model: model,
            )));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Material(
              color: Colors.transparent,
              elevation: 10,
              borderRadius: BorderRadius.circular(20.0),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.grey[200]),
                child: Row(
                  children: [
                    Stack(alignment: AlignmentDirectional.bottomEnd, children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(model.image!),
                        radius: 25.0,
                      ),
                      // CircleAvatar(
                      //   backgroundColor: model.status == "onLine"
                      //       ? Colors.green
                      //       : Colors.red,
                      //   radius: 6.0,
                      // ),
                    ]),
                    const SizedBox(width: 20.0),
                    Text(model.name!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        )),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
