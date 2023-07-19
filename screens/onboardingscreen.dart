import 'package:flutter/material.dart';
import 'package:projectt/authontication/welcomepage.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../network/sharedpreference.dart';
class BoardingModel{
  final String image;
  final String title;
  final String body;
  BoardingModel({required this.image,required this.title,required this.body});
}
class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  var  boardController=PageController();
  void submit(){
    CacheHelper.saveData(key: 'onBoarding', value: true).then((value){
      if(value){
        Navigator.pushNamed(context, 'welcomescreen');
     }
    }
    );
        }

  List<BoardingModel> boarding=[
    BoardingModel(image: "images/on1.jpeg", title: "Explore Egypt", body: "Fast discovering new places based on ratings and best recommendations "),
    BoardingModel(image: "images/on2.jpg", title: "Schedule your trip", body: "Choose the date , book your ticket quickly and plan your trip very easily "),
    BoardingModel(image: "images/on3.jpeg", title: "Let's enjoy", body: "Enjoy your holiday and  have amazing remarkable moments with your family and friends "),
  ] ;
bool isLast=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          actions: [TextButton(onPressed: (){
           submit();
          }, child: Text("skip",style: TextStyle(color: Colors.purple),))],
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  physics: BouncingScrollPhysics(),
                  onPageChanged: (int index){
                    if (index==boarding.length-1){
                      setState(() {
                        isLast=true;
                      });

                    }else{
                      setState(() {
                        isLast=false;
                      });
                    }
                  },
                  controller: boardController,
                  itemBuilder: (context, index) {
                    return buildBoardingItem(boarding[index]);
                  },
                  itemCount: boarding.length,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                children: [
                  SmoothPageIndicator(effect: ExpandingDotsEffect(
                      dotColor: Colors.grey,
                      dotHeight: 10,
                      expansionFactor: 4,
                      dotWidth: 10,
                      spacing: 5,
                      activeDotColor: Colors.purple
                  ),controller: boardController, count: boarding.length),
                  Spacer(),
                  FloatingActionButton(
                    onPressed: () {
                      if(isLast){
                      submit();
                      }else{
                        boardController.nextPage(duration: Duration(microseconds: 750), curve: Curves.fastLinearToSlowEaseIn);
                      }
                    },
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    ),
                    backgroundColor: Colors.purple,
                  )
                ],
              )
            ],
          ),
        ));
  }
}

  Column buildBoardingItem(BoardingModel boardingModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: Image(
                image: AssetImage(
                    "${boardingModel.image}"),fit: BoxFit.cover,)),
        SizedBox(
          height: 30,
        ),
        Text(
          "${boardingModel.title}",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          "${boardingModel.body}",
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 20,),
      ],
    );
    
  }








