import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectt/cubit/state.dart';

import '../../../../cubit/cubit.dart';

import '../../../models/message_model.dart';
import 'message_item.dart';

class ChatListView extends StatefulWidget {
  const ChatListView({Key? key}) : super(key: key);

  @override
  State<ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ListView.separated(
          itemBuilder: (context, index) {
            var message = AppCubit.get(context).messages[index];
            if (AppCubit.get(context).userModel!.uid == message.senderId)
            {
               return buildMyMesItem(message);
            }
            else if (AppCubit.get(context).userModel!.uid != message.senderId)
            {
              return buildReceiverMesItem(message);
            }
            return Container();
          },
          separatorBuilder: (context, index) =>const SizedBox(height: 15.0),
          itemCount: AppCubit.get(context).messages.length,
        );
      },
    );
  }

  Widget buildMyMesItem(MessageModel model) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: MessageItem(
        isSender: true,
        model: model,
        color: Colors.purple,
        textColor: Colors.white,
      ),
    );
  }

  Align buildReceiverMesItem(MessageModel model) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: MessageItem(
        isSender: false,
        model: model,
        color: Colors.grey[300]!,
        textColor: Colors.purple,
      ),
    );
  }
}
