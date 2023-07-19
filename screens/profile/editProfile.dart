import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectt/component/defaultbutton.dart';
import 'package:projectt/component/defaulttextformfield.dart';
import 'package:projectt/cubit/cubit.dart';
import 'package:projectt/cubit/state.dart';
import 'package:projectt/models/Users.dart';
import 'package:projectt/screens/endpoint.dart';
import 'package:projectt/screens/guest_ask_for_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import '../presentation/chat_detils_screen.dart';

class editProfile extends StatefulWidget {
  editProfile({Key? key, this.friend}) : super(key: key);
  Users? friend;

  @override
  State<editProfile> createState() => _editProfileState();
}

class _editProfileState extends State<editProfile> {
  bool? isTourGuide;
  @override
  void initState() {
    if(widget.friend != null)
    {
      namecontroller.text = widget.friend !.name!;
      phonecontroller.text =widget.friend !.phone!;
      emailcontroller.text = widget.friend !.email!;
      isTourGuide = widget.friend !.isTourGuide!;
    }
    else if (AppCubit.get(context).userModel != null) {
      AppCubit.get(context).profileImage = null;
      AppCubit.get(context).profileImageUrl = null;
      namecontroller.text = AppCubit.get(context).userModel!.name!;
      phonecontroller.text = AppCubit.get(context).userModel!.phone!;
      emailcontroller.text = AppCubit.get(context).userModel!.email!;
      isTourGuide = AppCubit.get(context).userModel!.isTourGuide!;
    }
    super.initState();
  }
  @override
  void dispose() {
    widget.friend = null;
    super.dispose();
  }
  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {

        return
          AppCubit.get(context).userModel != null || widget.friend != null
            ? Scaffold(
                backgroundColor: Colors.white,
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 80),
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 52,
                              backgroundColor: Colors.white,
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    image: DecorationImage(
                                      image:
                                        widget.friend != null ?
                                        NetworkImage(widget.friend!.image!) :
                                      AppCubit.get(context).profileImage == null
                                          ? NetworkImage("${AppCubit.get(context).userModel!.image}")
                                          : FileImage(File(AppCubit.get(context).profileImage!.path))
                                              as ImageProvider,
                                      fit: BoxFit.cover,
                                    )),
                              ),
                            ),
                            if (widget.friend == null)
                            CircleAvatar(
                              backgroundColor: Colors.purple,
                              radius: 20,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                onPressed: () {
                                  AppCubit.get(context).getProfileImage();
                                },
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 30),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Text("User information",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                                SizedBox(
                                  height: 20,
                                ),
                                defaultTextFormField(
                                  enabled: widget.friend == null,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Please enter your name";
                                    }
                                    return null;
                                  },
                                  obsuretext: false,
                                  textInputType: TextInputType.name,
                                  text: "name",
                                  controller: namecontroller,
                                  iconData: Icons.person,
                                  onpress: () {},
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                defaultTextFormField(
                                  enabled: widget.friend == null,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Please enter your email ";
                                    }
                                    return null;
                                  },
                                  obsuretext: false,
                                  textInputType: TextInputType.emailAddress,
                                  text: "email",
                                  controller: emailcontroller,
                                  iconData: Icons.email,
                                  onpress: () {},
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                defaultTextFormField(
                                  enabled: widget.friend == null,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Please enter your phone";
                                    }
                                    return null;
                                  },
                                  obsuretext: false,
                                  textInputType: TextInputType.phone,
                                  text: "phone",
                                  controller: phonecontroller,
                                  iconData: Icons.phone,
                                  onpress: () {},
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                  Container(
                                    padding: const EdgeInsets.only(left: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(color: widget.friend == null ? Colors.grey:Colors.grey.withOpacity(0.4))
                                    ),
                                    child: CheckboxListTile(
                                      enabled: widget.friend != null ?false:true,
                                      contentPadding: EdgeInsets.zero,
                                      activeColor:  Colors.purple,
                                      title:  Text("Tour Guide",style: TextStyle(color: Colors.black.withOpacity(0.6)),),
                                      value: isTourGuide,
                                      onChanged: (val) {
                                        setState(() {
                                          isTourGuide = val!;
                                        });
                                      },
                                    ),
                                  ),
                                const SizedBox(
                                  height: 20,
                                ),
                                  if (widget.friend == null)
                                  state is userUpdateLoadingState ?
                                const Center(child: CircularProgressIndicator(),) :
                                defaultButton(
                                  text: "Save",
                                  color: Colors.purple,
                                  onpressed: () {
                                   if(_formKey.currentState!.validate()){
                                     AppCubit.get(context).updateUser(
                                       name: namecontroller.text,
                                       email: emailcontroller.text,
                                        phone:   phonecontroller.text,
                                        isTourGuide:  isTourGuide!
                                     );
                                   }
                                  },
                                ),

                                if (widget.friend != null)
                                  Row(
                                    children: [
                                      Expanded(
                                        child: MaterialButton(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10)
                                          ),
                                          elevation: 10,
                                          height: 50,
                                          color: Colors.purple,
                                          onPressed: ()
                                          {
                                            if (asGuest != null)
                                            {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const GuestASkForAuth()));
                                            }
                                            else
                                            {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                       ChatDetailsScreen(model: widget.friend,)));

                                            }
                                            // todo chat

                                          },
                                          child:  Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children:const [
                                                Icon(Icons.send, color: Colors.white,),
                                                SizedBox(width: 10,),
                                                Text( "Send message", style: TextStyle(color: Colors.white),),
                                              ],
                                            ),
                                        ),
                                      ),

                                      const SizedBox(
                                        width: 20,
                                      ),
                                  Expanded(
                                    child: MaterialButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      elevation: 10,
                                      height: 50,
                                      color: Colors.purple,
                                      onPressed: ()
                                      {
                                        launchUrl(Uri.parse("mailto:${widget.friend!.email}"));
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children:const [
                                          Icon(Icons.alternate_email, color: Colors.white,),
                                           SizedBox(width: 10,),
                                           Text( "Via Gmail", style: TextStyle(color: Colors.white),),
                                        ],
                                      ),
                                    ),
                                  ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }
}
