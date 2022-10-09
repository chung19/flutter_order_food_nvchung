import 'package:flutter/material.dart';
import 'package:flutter_order_food_nvchung/data/datasources/local/cache/app_cache.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:lottie/lottie.dart';
import '../../../common/constants/variable_constant.dart';
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
    if(firstRun==true) {
      Navigator.pushReplacementNamed(context, VariableConstant.introRoute);
    }
    else if(firstRun==false){
    Future.delayed (Duration (seconds: 2)
    , () {
    String token = AppCache.getString(VariableConstant.token);
    if (token.isNotEmpty) {
    Navigator.pushReplacementNamed(context, VariableConstant.homeRoute);
    } else {
    Navigator.pushReplacementNamed(context, VariableConstant.signInRoute);
    }
    });
  }

  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.blueGrey,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Lottie.asset('assets/animations/animation_splash.json',
                animate: true, repeat: true),
            const Text("Welcome",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
                    color: Colors.white))
          ],
        ));
  }
}