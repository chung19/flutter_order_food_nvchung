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
  @override
  void initState() {
    super.initState();
    _checkFirstRun(context);
  }

  Future<void> _checkFirstRun(BuildContext context) async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
        // Future.delayed(Duration(seconds: 2), (){
     bool firstRun = prefs.getBool('firstRun') ?? true;
     String token = AppCache.getString(VariableConstant.token);
      if (firstRun && context.mounted) {
        prefs.setBool('firstRun', false);
        Navigator.pushReplacementNamed(context, VariableConstant.introRoute);
      } else if (token.isNotEmpty) {
        Navigator.pushReplacementNamed(context, VariableConstant.homeRoute);
      } else {
        Navigator.pushReplacementNamed(context, VariableConstant.signInRoute);
      }
    // });
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
              children: const [
                Text(
                  AppStrings.appName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
