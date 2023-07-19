import 'package:flutter/material.dart';

import '../../../models/Users.dart';

class ItemsContainer extends StatefulWidget {
  ItemsContainer(
      {Key? key,
      required this.date1,
      required this.model,
      required this.mesController,
      required this.documentOnPressed,
      required this.imageOnPressed})
      : super(key: key);
  final String date1;
  final Users model;
  final void Function()? documentOnPressed;
  final void Function()? imageOnPressed;
  final TextEditingController mesController;

  @override
  State<ItemsContainer> createState() => _ItemsContainerState();
}

class _ItemsContainerState extends State<ItemsContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: double.infinity,
      padding: const EdgeInsets.all(25.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.deepPurpleAccent,
                      child: IconButton(
                        color: Colors.white,
                        icon: const Icon(Icons.insert_drive_file),
                        onPressed: widget.documentOnPressed,
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    const Text("Documents"),
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.purpleAccent,
                      child: IconButton(
                        onPressed: widget.imageOnPressed,
                        icon: const Icon(Icons.photo),
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    const Text("Gallery"),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
