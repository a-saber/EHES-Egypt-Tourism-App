
import 'Users.dart';
import 'comments.dart';

class Postmodel{
  bool isLiked= false;
  String? uid;
  Users? user;

  String? datetime;
  String? text;
  String? postimage;
  String? postId;
  List<Commentmodel> comments = [];
  List<String> likes = [];

  Postmodel({this.postId, this.uid,  this.datetime, this.text, this.postimage});
  Postmodel.fromjson(Map<String,dynamic> json , String this.postId){
    uid=json['uid'];
    datetime=json['datetime'];
    text=json['text'];
    postimage=json['postimage'];
  }
 Map<String ,dynamic>tojson(){
    return {
      'uid':uid,
      'datetime':datetime,
      'text':text,
      'postimage':postimage
    };
  }
}