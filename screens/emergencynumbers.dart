import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
class EmergencyNumbers extends StatefulWidget {
  const EmergencyNumbers({Key? key}) : super(key: key);

  @override
  State<EmergencyNumbers> createState() => _EmergencyNumbersState();
}

class _EmergencyNumbersState extends State<EmergencyNumbers> {
  final number=['123','180','122','126 ','121','129','125','175','111','01221110000 '];
  final namesservies=['Ambulance','Firefighter','Police','Tourist Police ','Electricity Complaints','Gas Complaints','Water Complaints','Wastewater Complaints','Landline Complaints','Highway Cars Rescue '];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text("Emergency numbers",style: TextStyle(color: Colors.black),),centerTitle: true,
      ),
      body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemBuilder: (context,index){
              return InkWell(
                onTap: ()async{
                  await FlutterPhoneDirectCaller.callNumber(number[index]);
                },
                child: Card(
                  elevation: 3,
                  child: ListTile(
                    iconColor: Colors.black,
                    leading: Icon(Icons.call),
                    subtitle: Text("${namesservies[index]}"),
                    title: Text(number[index]),
                  ),
                ),
              );
            },itemCount: number.length,)
      ),
    );
  }
}
