import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../common/constants/variable_constant.dart';
import '../../../data/datasources/local/cache/app_cache.dart';
import '../../resources/assets-manager.dart';
import '../../resources/strings_manager.dart';
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  State<SplashPage> createState() => _SplashPageState();
}
class _SplashPageState extends State<SplashPage> {
  final _duration = const Duration(seconds: 2);
  @override
  void initState() {
    super.initState();
    _startTime();
  }

  Future<void> _startTime() async {
    final prefs = await SharedPreferences.getInstance();
    final firstRun = prefs.getBool('firstRun') ?? true;
    await Future.delayed(_duration);
    if (firstRun) {
      prefs.setBool('firstRun', false);
      navigationPageIntro();
    } else {
      final token = AppCache.getString(VariableConstant.token);
      if (token.isNotEmpty) {
        navigationPageHome();
      } else {
        navigationPageLogin();
      }
    }
  }
  void navigationPageHome(){
  Navigator.pushReplacementNamed(context, VariableConstant.homeRoute);
}
  void navigationPageLogin(){
    Navigator.pushReplacementNamed(context, VariableConstant.signInRoute);
  }
  void navigationPageIntro(){
    Navigator.pushReplacementNamed(context, VariableConstant.introRoute);
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF50baff),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [ 
            Container(
              margin: const EdgeInsets.only(top: 150),
              child: Lottie.asset(
                ImageAssets.animations33591cooker,
                animate: true,
                repeat: true,
              ),
            ),
            Column(
              children:  [
               AnimatedTextKit(
            animatedTexts: [
              TyperAnimatedText(AppStrings.appName),
              ScaleAnimatedText(AppStrings.appName),



          ],
        ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
