import 'package:flutter/material.dart';
import 'package:flutter_order_food_nvchung/data/datasources/local/cache/app_cache.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:lottie/lottie.dart';
import '../../../common/constants/variable_constant.dart';
import '../../../common/utils/type_writer_text_kit_nullsafety.dart';
class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    bool firstRun = await IsFirstRun.isFirstRun();
    Future.delayed ( const Duration (milliseconds:2500 )
    , () {

    String token = AppCache.getString(VariableConstant.token);
    if(firstRun==true)
      { Navigator.pushReplacementNamed(context, VariableConstant.introRoute);}
   else if (token.isNotEmpty) {
    Navigator.pushReplacementNamed(context, VariableConstant.homeRoute);
    }
    else {
    Navigator.pushReplacementNamed(context, VariableConstant.signInRoute);
    }
    });


  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(
        color: const Color(0xFF50baff),
        width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
               mainAxisAlignment: MainAxisAlignment.start,
                 // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 150),
                    child: Lottie.asset('assets/animations/33591-cooker.json',
                        animate: true, repeat: true),
                  ),
                  Column(
                    children:  const [
                      TypewriterAnimatedTextKit(text: ["FOODO"],duration: Duration(seconds: 2),textStyle: TextStyle(fontSize: 45,
                      color: Color(0xFFFEC00C),
                    ),)
                    ],
                  )
                ],
              ),
            ),
      ),
    );
  }
}