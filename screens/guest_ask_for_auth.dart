import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../authontication/login.dart';
import '../authontication/register.dart';
import '../component/defaultbutton.dart';
import '../cubit/cubit.dart';
import '../cubit/state.dart';

class GuestASkForAuth extends StatelessWidget {
  const GuestASkForAuth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Image(
                        image: AssetImage("images/pyramids.png"),
                        width: 50,
                        height: 50,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "EHES",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  const Text(
                    "Sorry, some features don\'t work if you don\'t have an account",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  defaultButton(
                    text: "Create an Account".toUpperCase(),
                    color: Colors.purple,
                    onpressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => register()));
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(

                      style: ElevatedButton.styleFrom(
                        elevation: 10,
                          primary: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 110, vertical: 20)),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => login()));
                      },
                      child: const Text("LOG IN",
                          style: TextStyle(color: Colors.black))),
                  const SizedBox(
                    height: 40,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    child: Center(
                        child: Text(
                          "By creating an account you agree to our Terms & condition and agree to privacy policy",
                          style: TextStyle(color: Colors.grey),
                        )),
                  )
                ],
              ),
            ),
          );
        },
        listener: (context, state) {});
  }
}
