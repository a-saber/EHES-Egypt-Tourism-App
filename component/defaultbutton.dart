import 'package:flutter/material.dart';
class defaultButton extends StatelessWidget {
  defaultButton({required this.text,required this.color,required this.onpressed});
  String text;
   Color color;
   Function()onpressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onpressed,
      child: Text(text),
      style: ElevatedButton.styleFrom(
          primary: color,
          padding: EdgeInsets.symmetric(horizontal: 60, vertical: 19)),
    );
  }
}
