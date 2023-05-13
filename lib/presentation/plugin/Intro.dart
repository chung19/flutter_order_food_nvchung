
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter/material.dart';

import '../../common/constants/variable_constant.dart';
import '../resources/assets-manager.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});
  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  List<PageViewModel> getPages() {
    return [
      PageViewModel(
          image: Image.asset(ImageAssets.FooD,width: double.infinity,fit: BoxFit.fill,),
          title: "Welcome to Food Paradise" ,
          body: ("Here we provide delicious dishes from fresh foods "),
          decoration:  PageDecoration(
            pageColor: Colors.white,
            titleTextStyle:   GoogleFonts.chewy(
            fontSize: 24,
            color: const Color(0xFFD54034),
            textStyle:
            Theme.of(context).textTheme.displayLarge,
          ),
            bodyTextStyle:   GoogleFonts.chewy(
            fontSize: 20,
            color: const Color(0xFF882820),
            textStyle:
            Theme.of(context).textTheme.displayLarge,
          ),
          )),
      PageViewModel(
        image: Image.asset(ImageAssets.Offer,width: double.infinity,fit: BoxFit.fill,),
        title: "Cheap tasty tonic ",
        body: "As our store selection criteria",
        footer:  Center(
          child: Text(
            'Let is Experience Together',
            style: GoogleFonts.chewy(
              fontSize: 20,
              color: const Color(0xFF56221E),
              textStyle:
              Theme.of(context).textTheme.displaySmall,
            ),
          ),
        ),
        decoration:  PageDecoration(
          pageColor: Colors.white10,
          titleTextStyle:   GoogleFonts.alice(
    fontSize: 24,
    color: const Color(0xffc91a1a),
    textStyle:

    Theme.of(context).textTheme.displaySmall,
    ),
          bodyTextStyle:   GoogleFonts.chewy(
    fontSize: 20,
    color: const Color(0xFF56221E),
    textStyle:
    Theme.of(context).textTheme.displaySmall,
    ),

        ),
      ),
      PageViewModel(
        image: Image.asset(ImageAssets.Delivery,width: double.infinity,fit: BoxFit.fill,),
        title: "Fast",
        body: "Convenience",
        footer:  Center(
          child: Text(
            'Easy 1-touch payment ',
            style: GoogleFonts.chewy(
    fontSize: 24,
    color: const Color(0xFF56221E),
    textStyle:
    Theme.of(context).textTheme.displaySmall,
    ),
          ),
        ),
        decoration:  PageDecoration(
          pageColor: Colors.white,
          titleTextStyle:   GoogleFonts.alice(
            fontSize: 24,
            color: const Color(0xffc91a1a),
            textStyle:

            Theme.of(context).textTheme.displaySmall,
          ),
          bodyTextStyle:   GoogleFonts.chewy(
    fontSize: 20,
    color: const Color(0xFF56221E),
    textStyle:
    Theme.of(context).textTheme.displaySmall,
    ),
        ),
      ),
      PageViewModel(
          image: Image.asset(ImageAssets.Cook,width: double.infinity,fit: BoxFit.fill,),
          title: "Happy Food ",
          body: "Touch is suck",
          footer:  Center(
            child: Text(
            'Eat now',
              style: GoogleFonts.chewy(
                fontSize: 20,
                color: const Color(0xFF56221E),
                textStyle:
                Theme.of(context).textTheme.displaySmall,
              ),
        ),
          ),
        decoration: PageDecoration(
          pageColor: Colors.white,
          titleTextStyle:   GoogleFonts.alice(
            fontSize: 24,
            color: const Color(0xffc91a1a),
            textStyle:

            Theme.of(context).textTheme.displaySmall,
          ),
          bodyTextStyle:  GoogleFonts.chewy(
    fontSize: 20,
    color: const Color(0xFF56221E),
    textStyle:
    Theme.of(context).textTheme.displaySmall,
    ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: IntroductionScreen(
        globalBackgroundColor: Colors.white,
        pages: getPages(),
        showNextButton: true,
        showSkipButton: true,
        skip: Container(
            margin: const EdgeInsets.symmetric(
              vertical: 5,
            ),
            padding: const EdgeInsets.fromLTRB(23.8, 2, 23.8,2),
            decoration: const BoxDecoration(
                color: Color(0xFFC91A1A),
                borderRadius:
                BorderRadius.all(Radius.circular(30))),
            child:  Text("Skip",style: GoogleFonts.atomicAge(
              color: const Color(0xFFF3F6F3),
            ),
            ),

        ),
        next: Container(
          margin: const EdgeInsets.symmetric(
            vertical: 5,
          ),
          padding: const EdgeInsets.fromLTRB(4, 2, 10,2),
          decoration: const BoxDecoration(
              color: Color(0xFF08EEB4),
              borderRadius:
              BorderRadius.all(Radius.circular(30))),

          child: Text(" Next",style: GoogleFonts.atomicAge(
          color: const Color(0xFFFFFFFF),
          ),),
        ),
        done: TextButton(
            onPressed: () {
              setState(() {

                Navigator.pushReplacementNamed(context, VariableConstant.signInRoute);


              });
            },
            child:
            Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 5,
                ),
                padding: const EdgeInsets.fromLTRB(8, 2, 8,2),
                decoration: const BoxDecoration(
                    color: Color(0xFF1B7CCC),
                    borderRadius:
                    BorderRadius.all(Radius.circular(30))),
                child: Text("Got it ",style:GoogleFonts.atomicAge(
                color: Color(0xFFF1F5F1),
              ) ,),
            ),),
        onDone: () {},
      ),
    );
  }
}