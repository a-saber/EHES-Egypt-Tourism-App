import 'package:flutter/material.dart';

class DeleteMeTwo extends StatefulWidget {
  const DeleteMeTwo({Key? key}) : super(key: key);

  @override
  State<DeleteMeTwo> createState() => _DeleteMeTwoState();
}

class _DeleteMeTwoState extends State<DeleteMeTwo> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(child: Text("2"),),
    );
  }
}

