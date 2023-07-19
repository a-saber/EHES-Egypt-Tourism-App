import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectt/component/defaultbutton.dart';
import 'package:projectt/component/defaulttextformfield.dart';
import 'package:projectt/cubit/state.dart';
import 'package:projectt/screens/mainscreens.dart';
import '../cubit/cubit.dart';

class login extends StatefulWidget {
  login({Key? key}) : super(key: key);

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailcontroller = TextEditingController();

  TextEditingController passwordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state)
      {
        if (state is loginSucessState )
        {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => mainScreens()));
        }
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              title: Text(
                "Log in",
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
            leading: IconButton(
                onPressed: ()
                {
                  Navigator.pop(context);
                }, icon: Icon(Icons.arrow_back,color: Colors.purple,)),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "welcome back! please log in to continue!",
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    defaultTextFormField(
                        obsuretext: false,
                        onpress: () {},
                        text: "EmailAddress",
                        controller: emailcontroller,
                        iconData: Icons.email,
                        textInputType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter your email ";
                          }
                          return null;
                        }),
                    SizedBox(
                      height: 15,
                    ),
                    defaultTextFormField(
                      text: "Password",
                      controller: passwordcontroller,
                      iconData: Icons.lock,
                      iconsuffix: cubit.isshow
                          ? Icons.visibility_off
                          : Icons.visibility,
                      textInputType: TextInputType.visiblePassword,
                      onpress: () {
                        cubit.show();
                      },
                      obsuretext: cubit.isshow,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "please enter your password ";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'forgetpassword');
                            },
                            child: Text(
                              "Forget Pssword?",
                              style: TextStyle(color: Colors.black),
                            ))),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        defaultButton(
                            text: "LOG IN",
                            color: Colors.purple,
                            onpressed: () {
                              if (_formKey.currentState!.validate()) {
                                cubit.makelogin( emailcontroller.text,
                                    passwordcontroller.text);
                              }

                            }),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),

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
