import 'message_model.dart';

class Users{
  String? name;
  String? email;
  String? phone;
  String? uid;
  String? token;
  String? image;
  bool? isTourGuide;
  MessageModel? lastMessage;

  Users({this.name,this.token, this.email,this.phone,this.uid,this.image, this.isTourGuide,this.lastMessage});
  Users.fromJson(Map<String,dynamic>? json){
    name=json!['name'];
    email=json['email'];
    phone=json['phone'];
    uid=json['uid'];
    token=json['token'];
    image=json['image'];
    isTourGuide=json['isTourGuide'];

  }
Map<String,dynamic> toJson(){
    return {
      'name':name,
      'email':email,
      'phone':phone,
      'uid':uid,
      'token':token,
      'image':image,
      'isTourGuide':isTourGuide,

    };
}
}