
import 'package:flutter/material.dart';
import 'package:flutter_order_food_nvchung/common/plugin/Intro.dart';
import 'package:flutter_order_food_nvchung/presentation/features/order/order_page.dart';
import 'package:flutter_order_food_nvchung/presentation/features/sign_in/sign_in_page.dart';
import 'package:flutter_order_food_nvchung/presentation/features/sign_up/sign_up_page.dart';
import 'common/constants/variable_constant.dart';
import 'data/datasources/local/cache/app_cache.dart';
import 'presentation/features/cart/cart_page.dart';
import 'presentation/features/home/home_page.dart';
import 'presentation/features/splash/splash_page.dart';

void main() {
  runApp( MyApp());

  AppCache.init();
}

class MyApp extends StatelessWidget {

  // const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        fontFamily: "QuickSan",
        primarySwatch: Colors.blue,
      ),
      routes: {
        VariableConstant.signInRoute: (context) => SignInPage(),
        VariableConstant.signUpRoute: (context) => SignUpPage(),
        VariableConstant.homeRoute: (context) => HomePage(),
        VariableConstant.splashRoute: (context) => SplashPage(),
        VariableConstant.cartRoute: (context) =>CartPage(),
        VariableConstant.orderRoute: (context) =>OrderPage(),
       VariableConstant.introRoute: (context) =>Intro(),
      },
      initialRoute: VariableConstant.splashRoute  ,
    );
  }
}

