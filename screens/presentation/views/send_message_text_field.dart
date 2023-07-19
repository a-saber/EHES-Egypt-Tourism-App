import 'package:flutter/material.dart';

import '../../../models/Users.dart';

class SendMessageTextField extends StatefulWidget {
  SendMessageTextField(
      {Key? key,
      required this.date1,
      required this.mesController,
      required this.model,
      required this.onPressed,
      required this.sendOnPressed})
      : super(key: key);
  final String date1;
  final void Function()? onPressed;
  final Users model;

  final void Function()? sendOnPressed;
  final TextEditingController mesController;
  @override
  State<SendMessageTextField> createState() => _SendMessageTextFieldState();
}

class _SendMessageTextFieldState extends State<SendMessageTextField> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: TextFormField(
                controller: widget.mesController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                hintText: "Enter Your Message..."))),
        IconButton(
          onPressed: widget.onPressed,
          icon: Icon(
            Icons.attach_file_sharp,
            color: Colors.purple,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        IconButton(
          onPressed: widget.sendOnPressed,
          icon: Icon(
            Icons.send,
            color: Colors.purple,
          ),
        ),
      ],
    );
  }
}
