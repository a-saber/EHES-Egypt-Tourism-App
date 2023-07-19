import 'package:flutter/material.dart';

class Tourguide{
 String? image;
 String? name;
 String? email;

 Tourguide(this.image,this.email,this.name);
 Tourguide.fromjson(Map<String,dynamic> json){
   image=json['image'];
   name=json['name'];
   email=json['email'];
 }
}