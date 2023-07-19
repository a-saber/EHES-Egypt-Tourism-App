import 'Users.dart';

class Commentmodel{
  String? commentId;
  String? text;
  String? datetime;
  String? uId;
  Users? user;
  Commentmodel({this.uId,this.text,this.datetime,this.commentId});
  Commentmodel.fromjson(Map<String,dynamic>json){
    text=json['text'];
    datetime=json['datetime'];
    uId=json['uId'];
    commentId=json['commentId'];
  }
  Map<String,dynamic>tomap(){
    return {
      'uId':uId,
      'datetime':datetime,
      'text':text,
      'commentId':commentId
    };
  }
}