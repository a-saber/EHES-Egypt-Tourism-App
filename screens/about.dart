import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "About",style: TextStyle(color: Colors.black),

        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22,vertical: 5),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "Our application aims to support tourism in our country Egypt. By using the app there is no need to a tour guide no more to discover Egypt because our application helps you to know about (historical places , tourism  places , restaurants, cafes and hotels) so you don’t miss your opportunity to visit places you never visited or seen before and know more information about them. Planning your trip should be simple and fun  using EHES in a fast way and anyone can use it which works to saveA great deal of time,  as it is free app.",

                  style: TextStyle(fontSize: 20, height: 1.8),
                ),
                SizedBox(height: 10,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
