
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter/material.dart';
import '../constants/variable_constant.dart';
class Intro extends StatefulWidget {
  const Intro({Key? key}) : super(key: key);
  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  List<PageViewModel> getPages() {
    return [
      PageViewModel(
          image: Image.asset("assets/images/intro_food1.jpg",width: double.infinity,fit: BoxFit.fill,),
          title: "Welcome to Food Paradise",
          body: ("Here we provide delicious dishes from fresh foods "),
          decoration: const PageDecoration(
            pageColor: Colors.blue,
            titleTextStyle: TextStyle(color: Color(0xFF56D084),fontWeight: FontWeight.w700, fontSize: 24.0),
            bodyTextStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0,color: Color(
                0xFF154FD3),),
          )),
      PageViewModel(
        image: Image.asset("assets/images/intro_food2.jpg",width: double.infinity,fit: BoxFit.fill,),
        title: "Cheap tasty tonic ",
        body: "As our store selection criteria",
        footer: const Text(
          'Let is Experience Together',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF56221E),
          ),
        ),
        decoration: const PageDecoration(
          pageColor: Colors.limeAccent,
          titleTextStyle: TextStyle(color: Color(0xFF2052D2),fontWeight: FontWeight.w700, fontSize: 24.0),
          bodyTextStyle: TextStyle(color: Color(0xFF56D084),fontWeight: FontWeight.w700, fontSize: 20.0),

        ),
      ),
      PageViewModel(
        image: Image.asset("assets/images/intro_food3.jpg",width: double.infinity,fit: BoxFit.fill,),
        title: "Fast",
        body: "Convenience",
        footer: const Text(
          'Easy 1-touch payment ',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFFE7CD1A),
          ),
        ),
        decoration: const PageDecoration(
          pageColor: Colors.pink,
          titleTextStyle: TextStyle(color: Color(0xFF56D084),fontWeight: FontWeight.w700, fontSize: 24.0),
          bodyTextStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0,color: Color(
              0xFF154FD3),),
        ),
      ),
      PageViewModel(
          image: Image.asset("assets/images/intro_food4.jpg",width: double.infinity,fit: BoxFit.fill,),
          title: "Happy Food ",
          body: "Touch is suck",
          footer:  const Text(
          'Eat now',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF60CB49),
          ),
        ),
        decoration: const PageDecoration(
          pageColor: Colors.teal,
          titleTextStyle: TextStyle(color: Color(0xFFC91A1A),fontWeight: FontWeight.w700, fontSize: 24.0),
          bodyTextStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0,color: Color(
              0xFF154FD3),),
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
        skip: const Text("Skip"),
        done: TextButton(
            onPressed: () {
              setState(() {

                Navigator.pushReplacementNamed(context, VariableConstant.signInRoute);


              });
            },
            child: const Text("Got it ")),
        onDone: () {},
      ),
    );
  }
}