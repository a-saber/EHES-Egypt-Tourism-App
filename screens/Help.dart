import 'package:flutter/material.dart';
import 'package:projectt/models/help.dart';
class Helpp extends StatelessWidget {
   Helpp({Key? key}) : super(key: key);
   List<dynamic> question=[
     Help(" Where is the main bus depot in Cairo?", "The main bus depot is called Cairo Gateway (El Torgoman) bus station and is situated just off the city center. Any taxi will be able to take you there."),
     Help("Where do I get the bus in Luxor?", "The bus station in Luxor is situated behind the Luxor Temple"),
     Help("Where do I get the bus in Hurghada?", "The bus station is situated in Hurghada town center."),
     Help(" Where do I get the bus in Sharm El-Sheikh?", "The bus station is on the outskirts of the town on Freedom Road. You will require a taxi to get there, though many hotels do have shuttle buses which can do this."),
     Help("How do I get from Hurghada to Aswan?", "Many travel books mention the road and bus service between these two towns, but these are not advised for tourists and the buses will often refuse admittance. The advised route is to get the bus to Luxor and then the train to Aswan."),
     Help("Can I just turn up at the bus station and buy a ticket?", "You can, but you are advised to get your tickets at least 24 hours before travel, if possible. If you wait until the last minute you may find that you cannot get seats that are next to one another, or they may even be at separate ends of the bus. Not a good idea if you have children with you."),
     Help(" Is it safe to drive in Egypt?", "Unless you are used to the way that Egyptians drive, it is not advised to attempt this. Lane etiquette is unknown, cars will cut you to make a turn, and the use of lights during the night is very seldom done. Though some road signs are in English and Arabic, the majority are in Arabic alone and there are simply not any good road maps, especially town ones"),
     Help("What are the differences between bed and breakfast, half board, full board and all inclusive?Bed and breakfast mean that only breakfast is supplied.", "Half board means that breakfast and dinner are suppliedThe full board has all meals supplied (breakfast, lunch, and dinner)All inclusive means that all meals and drinks are supplied; some hotels also supply alcohol. This latter point should be checked when making the booking."),
     Help("how to enjoy Egypt during Ramadan as a tourist?", " Ramadan is the ninth month of Islamic Calendar with the beginning and end marked by the astronomical new moon, so it always falls on the same day of the Islamic Calendar (a lunar calendar), but the date on Gregorian Calendar (a solar calendar) varies from year to year. It is a month of fasting, prayer, and introspection, so Muslims abstain from eating, drinking, smoking and immoral behaviors from sunrise to sunset every day. They also appreciate that non-Muslim don't eat, drink or smoke in the public."),
     Help("Can I take pictures inside the temples and tombs?", "it’s hard to think of a more enduringly photogenic place than Egypt. From the Great Pyramids to King Tut’s funeral mask, images of these ancient remains are etched in our brains from childhood. As you can imagine, preserving these relics is of utmost importance so there are photography rules (especially against using a flash) in most temples and tombs. The rules change often and vary from site to site, so it’s best to ask your CEO and confirm what’s allowed before entering. Some temples charge photography fees if you want to use anything other than your smartphone or forbid pictures outright like in Tutankhamun’s tomb."),
     Help("What should I wear in Egypt? ","Dress in clothing that breathes well as it’s likely to be hot depending on when you travel. Some mosques ask that you cover your hair when visiting.It’s advisable to cover your arms, legs, and chest while visiting conservative or religious monuments & areas out of respect. Save your skin-baring outfits for the beach resorts and Western-style hotels (this goes for men too)."),
     Help("Can you climb the pyramids of Giza? ", "No, you cannot climb the pyramids. If you do, you may find yourself in a cozy Egyptian prison for who knows how long. That said, I saw someone climb to the top of one of the queens' pyramids (smaller ones at Giza) this week."),
     Help("Are things cheaper in Egypt? ", "Many things are cheaper in Egypt, and many things are similar in cost to your home country. It really depends on your travel style. Budget travelers can travel easily within Egypt because there are lots of options. "),
     Help("What should I avoid in Egypt? ", "You should avoid tap water, ice cubes, the fruit & vegetables you can’t peel, and some say salad altogether.Avoid camels if you don't like bumpy rides!I don’t avoid the salads in bustling restaurants, but you may want to avoid salad from a street cart. It depends on how sensitive your stomach is.You may want to avoid giving out your phone number because everyone will ask for it and they will definitely use it.That being said, you will make many friends in the land of Pharaohs!"),
     Help("Is Egypt safe for tourists?", "Everyone’s opinion differs on this subject, but my feeling is Egypt is much safer than the United States if I were to compare. Petty crime is rare, and it’s illegal to own guns, so there’s that.Egypt also has Tourist Police and soldiers at nearly every corner to patrol for safety. If you are a female solo traveler, use the same judgment you would in any country you are unfamiliar with."),
     Help("Do they drink alcohol in Egypt? ", "Egypt is a Muslim country, and Muslims are forbidden to drink alcohol.You can find alcohol at all the Western-style hotels and bars, as well as many nightclubs. Drinkies is a popular store you can buy beer and wine with locations all around Cairo.Try the local beer, Sakara; it’s delightful"),
     Help("Can I take pictures and videos everywhere?", "Do not photograph government buildings, military compounds, soldiers, police, or the general public in conservative areas.Be careful about photographing any area with trash as Egyptian authorities are serious about preventing Egypt from being seen in a bad light. You may be approached and required to erase your footage. "),
     Help("Do I need a visa for Egypt? ", "yes, you can buy your visa right at the airport for 25. It’s not necessary to arrange a visa before you travel. "),
   ] ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Question & Answer",style: TextStyle(color: Colors.black),),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(itemBuilder: (context,index){
            return buildExpansionTile(question[index]);
          },itemCount: question.length,),
        ),
      )

    );
  }

  ExpansionTile buildExpansionTile(question ) {
    return ExpansionTile(
      initiallyExpanded: true,
      collapsedTextColor: Colors.black,
      backgroundColor: Colors.white,
      leading: Icon(Icons.info_outline),
      title: Text(question.question,style: TextStyle(fontSize: 18),),
      children: [
        Align(
            alignment: Alignment.topLeft,
            child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.white),
                child: Text("${question.answer}",
                    style: TextStyle(
                      height: 1.7,
                        color: Colors.black.withOpacity(0.6),
                        fontSize: 16),textAlign: TextAlign.center,))),
      ],
    );
  }

}

