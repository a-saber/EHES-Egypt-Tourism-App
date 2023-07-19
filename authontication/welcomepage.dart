import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectt/authontication/login.dart';
import 'package:projectt/authontication/register.dart';
import 'package:projectt/component/defaultbutton.dart';
import 'package:flutter/material.dart';
import 'package:projectt/cubit/cubit.dart';
import 'package:projectt/cubit/state.dart';
import 'package:projectt/network/sharedpreference.dart';
import 'package:projectt/screens/endpoint.dart';
import 'package:projectt/screens/mainscreens.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Padding(
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
                      height: 40,
                    ),
                    const Text(
                      "Search less , travel more !",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text("Great experience at backpacker prices"),
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
                      height: 40,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            padding: EdgeInsets.symmetric(
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
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 100, vertical: 20)),
                        onPressed: () async {
                          CacheHelper.saveData(key: 'asGuest', value: true)
                              .then((value) {
                            asGuest = true;
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => mainScreens()));
                          });
                        },
                        child: const Text("as a guest",
                            style: TextStyle(color: Colors.black))
                    ),
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
            ),
          );
        },
        listener: (context, state) {});
  }
}
