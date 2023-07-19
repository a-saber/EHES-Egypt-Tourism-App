import 'package:flutter/material.dart';

import '../../../../cubit/cubit.dart';
import '../../../models/message_model.dart';

class MessageItem extends StatelessWidget {
  const MessageItem(
      {Key? key,
      required this.model,
      required this.color,
      required this.isSender,
      required this.textColor})
      : super(key: key);
  final MessageModel model;
  final Color color;
  final Color textColor;
  final bool isSender;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        //AppCubit.get(context).onLongPressed(true, model.messageId!);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        decoration: BoxDecoration(
            borderRadius: isSender ?
            const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
                bottomRight: Radius.circular(0))
                :
            const BorderRadius.only(
                bottomLeft: Radius.circular(0),
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
                bottomRight: Radius.circular(40))

            ,
            color: color),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Text(
                model.text!,
                maxLines: 3,
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: textColor,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: Text(
                model.dateTime!.substring(11, 16),
                style: TextStyle(color: textColor),
              ),
            )
          ],
        )

        ,
      ),
    );
    ;
  }
}
