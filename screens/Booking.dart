// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
// import 'package:intl_phone_field/intl_phone_field.dart';
// import 'package:projectt/component/defaultbutton.dart';
// import 'package:projectt/component/defaulttextformfield.dart';
// import 'package:projectt/cubit/cubit.dart';
// import 'package:projectt/cubit/state.dart';
// import 'package:projectt/models/PlaceModel.dart';
// import 'package:projectt/models/plan_model.dart';
// import 'package:projectt/screens/endpoint.dart';
// import 'package:projectt/screens/guest_ask_for_auth.dart';
// import 'package:toast/toast.dart';
//
//
// class booking extends StatefulWidget {
//   PlaceModel? religion;
//   booking(this.religion);
//
//   @override
//   State<booking> createState() => _bookingState();
// }
//
// class _bookingState extends State<booking> {
//   TextEditingController _arrivaldate = TextEditingController();
//   TextEditingController _departuredate = TextEditingController();
//   var emailController = TextEditingController();
//   var phoneController = TextEditingController();
//   var nameController = TextEditingController();
//   var extraController = TextEditingController();
//   var countrycodecontroller = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//
//   _bookingState() {
//     _selectedVal = _titleList[0];
//   }
//
//   final _titleList = ["Mr", "Ms", "Mrs"];
//   String? _selectedVal = "";
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => AppCubit(),
//       child: BlocConsumer<AppCubit, AppStates>(
//         listener: (context, state) {},
//         builder: (context, state) {
//           return Scaffold(
//             body: SingleChildScrollView(
//                 child: Padding(
//               padding: const EdgeInsets.all(25.0),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       SizedBox(
//                         height: 20,
//                       ),
//                       DropdownButtonFormField(
//                         value: _selectedVal,
//                         items: _titleList
//                             .map((e) => DropdownMenuItem(
//                                   child: Text(e),
//                                   value: e,
//                                 ))
//                             .toList(),
//                         onChanged: (val) {
//                           setState(() {
//                             _selectedVal = val as String;
//                           });
//                         },
//                         icon: Icon(Icons.arrow_drop_down),
//                         decoration:
//                             InputDecoration(border: OutlineInputBorder()),
//                       ),
//                       SizedBox(
//                         height: 10.0,
//                       ),
//                       defaultTextFormField(
//                           validator: (value) {
//                             if (value.isEmpty) {
//                               return "Please enter your name";
//                             }
//                             return null;
//                           },
//                           obsuretext: false,
//                           onpress: () {},
//                           textInputType: TextInputType.name,
//                           text: "Name",
//                           controller: nameController,
//                           iconData: Icons.person),
//                       SizedBox(
//                         height: 10.0,
//                       ),
//                       defaultTextFormField(
//                           validator: (value) {
//                             if (value.isEmpty) {
//                               return "Please enter your email ";
//                             }
//                             return null;
//                           },
//                           obsuretext: false,
//                           onpress: () {},
//                           textInputType: TextInputType.emailAddress,
//                           text: "Email",
//                           controller: emailController,
//                           iconData: Icons.email),
//                       const SizedBox(
//                         height: 10.0,
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       IntlPhoneField(
//                         decoration: const InputDecoration(
//                           border: OutlineInputBorder(
//                             borderSide: BorderSide(),
//                           ),
//                         ),
//                         controller: countrycodecontroller,
//                         initialCountryCode: 'IN',
//                         obscureText: false,
//                         autofocus: true,
//                         keyboardType: TextInputType.number,
//                         onChanged: (phone) {
//                           print(phone.completeNumber);
//                         },
//                       ),
//                       const SizedBox(
//                         height: 10.0,
//                       ),
//                       defaultTextFormField(
//                           validator: (value) {
//                             if (value.isEmpty) {
//                               return "Please enter your phone";
//                             }
//                             return null;
//                           },
//                           obsuretext: false,
//                           onpress: () {},
//                           textInputType: TextInputType.phone,
//                           text: "Phone",
//                           controller: phoneController,
//                           iconData: Icons.phone),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       TextFormField(
//                         keyboardType: TextInputType.datetime,
//                         controller: _arrivaldate,
//                         decoration: const InputDecoration(
//                           prefixIcon: Icon(Icons.calendar_month_rounded),
//                           labelText: "Arrival Date",
//                           border: OutlineInputBorder(
//                             borderSide: BorderSide(),
//                           ),
//                         ),
//                         onTap: () async {
//                           // var DataTime;
//                           showDatePicker(
//                                   context: context,
//                                   initialDate: DateTime.now(),
//                                   firstDate: DateTime(2000),
//                                   lastDate: DateTime(2101))
//                               .then((value) {
//                             _arrivaldate.text =
//                                 DateFormat.yMMMMEEEEd().format(value!);
//                           });
//                         },
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       TextFormField(
//                         keyboardType: TextInputType.datetime,
//                         controller: _departuredate,
//                         decoration: const InputDecoration(
//                           prefixIcon: Icon(Icons.calendar_month_rounded),
//                           labelText: "Departure Date",
//                           border: OutlineInputBorder(
//                             borderSide: BorderSide(),
//                           ),
//                         ),
//                         onTap: () async {
//                           showDatePicker(
//                                   context: context,
//                                   initialDate: DateTime.now(),
//                                   firstDate: DateTime(2000),
//                                   lastDate: DateTime(2101))
//                               .then((value) {
//                             _departuredate.text =
//                                 DateFormat.yMMMMEEEEd().format(value!);
//                           });
//                         },
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       defaultTextFormField(
//                         validator: (value) {
//                           if (value.isEmpty) {
//                             return "Please enter your notes";
//                           }
//                         },
//                         obsuretext: false,
//                         textInputType: TextInputType.text,
//                         text: "Extra Note",
//                         controller: extraController,
//                         iconData: Icons.note_alt,
//                         onpress: () {},
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       defaultButton(
//                           text: "Book ",
//                           color: Colors.purple,
//                           onpressed: () {
//                             if (_formKey.currentState!.validate()) {
//                               if(asGuest == null) {
//                                 AppCubit.get(context).addToPlan(PlanModel(placeId: "",date: "",time: "",status: "new"), context);
//                               }
//                               else
//                               {
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) =>const GuestASkForAuth()));
//                               }
//                             }
//                           })
//                     ]),
//               ),
//             )),
//           );
//         },
//       ),
//     );
//   }
// }
