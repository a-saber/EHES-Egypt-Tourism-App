import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectt/cubit/cubit.dart';
import 'package:projectt/cubit/state.dart';
class mainScreens extends StatelessWidget {
   mainScreens({Key? key}) : super(key: key);
TextEditingController searchcontroller=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener:(context,state){} ,
      builder: (context,state){
        var cubit=AppCubit.get(context);
        return Scaffold(
            backgroundColor: Colors.white,
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: BottomNavigationBar(
                showSelectedLabels: true,
                currentIndex:cubit.currentindex ,
                onTap: (index){
                  cubit.changepage(index);
                },
                selectedItemColor: Colors.purple,
                unselectedItemColor: Colors.grey,
                type: BottomNavigationBarType.fixed,

                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.home),label: "Home"),
                  BottomNavigationBarItem(icon: Icon(Icons.favorite),label: "Favourite"),
                  BottomNavigationBarItem(icon: Icon(Icons.map),label: "My plan"),
                  BottomNavigationBarItem(icon: Icon(Icons.question_answer),label: "Inquiry"),
                  BottomNavigationBarItem(icon: Icon(Icons.person),label: "Profile"),
                  BottomNavigationBarItem(icon: Icon(Icons.chat_outlined),label: "Chat"),
                  BottomNavigationBarItem(icon: Icon(Icons.money_rounded),label: "Currencies"),

                ],
              ),
            ),
            body:cubit.screens[cubit.currentindex]
        );
      },

    );
  }
}
