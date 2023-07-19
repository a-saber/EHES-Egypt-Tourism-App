import 'package:intl/intl.dart';

class Booking{
  String? name;
  String? email;
  String? phone;
  String? extranote;
  String? type;
  String? arrive;
  String? departuredate;
  String? countrycode;
  String? placeid;
  String? imageplace;
  String? locationplace;
  String? nameplace;
  Booking({this.name,this.email,this.phone,this.extranote,this.type,this.countrycode,this.arrive,this.departuredate,this.placeid,this.imageplace,this.nameplace,this.locationplace});
  Booking.fromjson(Map<String,dynamic>json){
   name=json['name'];
   email=json['email'];
   phone=json['phone'];
   extranote=json['extranote'];
   type=json['type'];
   arrive=json['arrive'];
   departuredate=json['departuredate'];
   countrycode=json['countrycode'];
   placeid=json['placeid'];
   imageplace=json['imageplace'];
   locationplace=json['locationplace'];
   nameplace=json['nameplace'];
  }
  Map<String,dynamic>tomap(){
    return {
      'name':name,
      'email':email,
      'phone':phone,
      'extranote':extranote,
      'type':type,
      'arrive':arrive,
      'departuredate':departuredate,
      'countrycode':countrycode,
      'placeid':placeid,
      'imageplace':imageplace,
      'locationplace':locationplace,
      'nameplace':nameplace
    };
  }
}

