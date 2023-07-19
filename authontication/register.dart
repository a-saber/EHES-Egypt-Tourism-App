import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectt/component/defaulttextformfield.dart';
import 'package:projectt/component/defaultbutton.dart';
import 'package:projectt/cubit/cubit.dart';
import 'package:projectt/cubit/state.dart';
import 'package:projectt/screens/TermsAndConditions.dart';

class register extends StatefulWidget {
  register({Key? key}) : super(key: key);

  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {
  TextEditingController namecontroller = TextEditingController();

  TextEditingController emailcontroller = TextEditingController();

  TextEditingController phonecontroller = TextEditingController();

  TextEditingController passwordcontroller = TextEditingController();

  bool isTourGuide = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text(
                "Create Account",
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.purple,
                  )),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                          "Sign up to keep exploring amazing destinations around the world!"),
                      const SizedBox(
                        height: 30,
                      ),
                      defaultTextFormField(
                        obsuretext: false,
                        onpress: () {},
                        text: "Full Name",
                        controller: namecontroller,
                        iconData: Icons.person_pin,
                        textInputType: TextInputType.name,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter your name";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 15,
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
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      defaultTextFormField(
                          obsuretext: false,
                          onpress: () {},
                          text: "phone",
                          controller: phonecontroller,
                          iconData: Icons.phone,
                          textInputType: TextInputType.phone,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter your phone";
                            }
                            return null;
                          }),
                      SizedBox(
                        height: 15,
                      ),
                      defaultTextFormField(
                        obsuretext: cubit.isshow,
                        text: "password",
                        controller: passwordcontroller,
                        iconData: Icons.lock,
                        iconsuffix: cubit.isshow
                            ? Icons.visibility_off
                            : Icons.visibility,
                        textInputType: TextInputType.visiblePassword,
                        onpress: () {
                          cubit.show();
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter your password";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.grey)),
                        child: CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          activeColor: Colors.purple,
                          title: Text(
                            "I'm a Tour Guide",
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.6)),
                          ),
                          value: isTourGuide,
                          onChanged: (val) {
                            setState(() {
                              isTourGuide = val!;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          defaultButton(
                              text: "LET'S GET STARTED",
                              color: Colors.purple,
                              onpressed: () {
                                if (_formKey.currentState!.validate()) {
                                  cubit.makeregister(
                                      namecontroller.text,
                                      emailcontroller.text,
                                      passwordcontroller.text,
                                      phonecontroller.text,
                                      context,
                                      isTourGuide);
                                }
                              }),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        TermsAndConditions()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Text(
                              "By creating an account .you agree to our Terms & conditions and agree to privacy policy ",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
