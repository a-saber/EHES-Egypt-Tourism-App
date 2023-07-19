import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectt/cubit/cubit.dart';
import 'package:projectt/cubit/state.dart';

class defaultTextFormField extends StatelessWidget {
  defaultTextFormField(
      {required this.text,
      required this.controller,
       this.iconData,
      this.iconsuffix,
      required this.textInputType,
       this.onpress,
      required this.obsuretext,
    required  this.validator,
        this.onChange,
        this.enabled = true
      });

  String text;
  bool enabled;
  TextEditingController controller;
  IconData? iconData;
  IconData? iconsuffix;
  TextInputType textInputType;
  void Function()? onpress;
  void Function(String)? onChange;
  bool obsuretext;
  final FormFieldValidator validator;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return TextFormField(
          enabled: enabled,
          onChanged: onChange,
            keyboardType: textInputType,
            controller: controller,
            obscureText: obsuretext,
            validator: validator,

            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.purple,width: 2)),
              hintText: text,
              suffixIcon: iconsuffix == null?
                  null:
              IconButton(
                icon: Icon(iconsuffix),
                onPressed: onpress
              ),
              contentPadding: EdgeInsets.only(top: 20, bottom: 20,left: 10),
              border: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Colors.black),
                  borderRadius: BorderRadius.circular(5)),
              prefixIcon: iconData == null ? null:Icon(iconData),
            ));

      },
    );
  }
}
