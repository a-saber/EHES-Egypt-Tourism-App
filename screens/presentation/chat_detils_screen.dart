import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectt/cubit/cubit.dart';
import 'package:projectt/screens/presentation/views/chat_listview.dart';
import 'package:projectt/screens/presentation/views/items_container.dart';
import 'package:projectt/screens/presentation/views/send_message_text_field.dart';

import '../../cubit/state.dart';
import '../../models/Users.dart';
import '../../network/fcn_notification.dart';


class ChatDetailsScreen extends StatefulWidget {
  Users? model;

  ChatDetailsScreen({super.key, this.model});

  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen> {
  var mesController = TextEditingController();
  bool ispressed = false;

  bool isDocument = false;

  bool isImage = false;

  @override
  void dispose() {
    mesController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    AppCubit.get(context).messages=[];
    AppCubit.get(context).getMessages(receiverId: widget.model!.uid!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //SizeConfig().init(context);
    final String date1 = DateTime.now().toString();
    return Builder(
      builder: (BuildContext context) {
        return BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0.0,
                  title: Column(
                    children: [
                      Text(
                        widget.model!.name!,
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      // Text(
                      //   widget.model!.status!,
                      //   style: TextStyle(color: Colors.purple, fontSize: 15),
                      // ),
                    ],
                  ),
                  centerTitle: true,
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.purple,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  actions: [
                   // if (AppCubit.get(context).press)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundImage:
                                  NetworkImage(widget.model!.image!),
                            ),
                          ]),
                    )
                  ],
                ),
                body: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            const ChatListView(),
                            ispressed
                                ? ItemsContainer(
                                    imageOnPressed: () async {
                                      // await AppCubit.get(context)
                                      //     .getImageFile(
                                      //         receiverId: widget.model!.uId!,
                                      //         dateTime: date1);
                                      // mesController.text =
                                      //     AppCubit.get(context)
                                      //         .f_model
                                      //         .fileName!;
                                      // setState(() {
                                      //   ispressed = false;
                                      //   isImage = true;
                                      // });
                                    },
                                    date1: date1,
                                    model: widget.model!,
                                    mesController: mesController,
                                    documentOnPressed: () {
                                      // AppCubit.get(context)
                                      //     .getDocumentFile(
                                      //         receiverId: widget.model!.uId!,
                                      //         dateTime: date1)
                                      //     .then((value) {
                                      //   setState(() {
                                      //     ispressed = false;
                                      //     isDocument = true;
                                      //   });
                                      // });
                                    },
                                  )
                                : const SizedBox()
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            border: Border.all(
                                color: Colors.grey[300]!, width: 1.0)),
                        child: SendMessageTextField(
                          sendOnPressed: () {

                              AppCubit.get(context).sendMessage(
                                receiverId: widget.model!.uid!,
                                text: mesController.text,
                                dateTime: date1,
                              );
                              LocalNotificationService.sendNotification(
                                  token: widget.model!.token!,
                                  message: mesController.text,
                                  title: "new message")
                                  .then((value) {
                                print(
                                    "message sent successfully ${mesController.text} ====================");
                              });
                              setState(() {
                                mesController.text = "";
                              });

                          },
                          date1: date1,
                          mesController: mesController,
                          model: widget.model!,
                          onPressed: () {
                            setState(() {
                              ispressed = true;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ));
          },
        );
      },
    );
  }
}
