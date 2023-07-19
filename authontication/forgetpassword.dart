import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectt/component/defaultbutton.dart';
import 'package:projectt/component/defaulttextformfield.dart';
import 'package:projectt/cubit/cubit.dart';
import 'package:projectt/cubit/state.dart';
class forgetPassword extends StatelessWidget {
   forgetPassword({Key? key}) : super(key: key);
   final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>AppCubit(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){},
        builder: (context,state){
          var cubit=AppCubit.get(context);
          return Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _formKey,
                   child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Receive an email to reset your password",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
                    SizedBox(height: 20,),
                    defaultTextFormField(onpress: (){},text: "email", controller: cubit.emailcontroller, iconData: Icons.track_changes,textInputType: TextInputType.emailAddress,obsuretext: false,validator: (value){
                      if(value.isEmpty)
                        {
                                 return "Please enter your email ";
                        }else if(value!.content("@"))
                          {
                            return "your email must contain @ ";
                          }
                      return null;
                    },),
                    SizedBox(height: 20,),
                    defaultButton(text: "Reset password", color: Colors.purple, onpressed: (){
                   if(_formKey.currentState!.validate()){
                     cubit.resetpassword(context);
                   };

                    })
                  ],
                ),
              ),
            ),
          );
        },

      ),
    );
  }
}
