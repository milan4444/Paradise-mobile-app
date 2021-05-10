import 'package:flutter/material.dart';

import '../screens/login.dart';
import '../screens/main_screen.dart';
import '../screens/register_screen.dart';
import '../screens/home.dart';
import '../screens/chatbot.dart';


class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case MainScreen.routeName:
        return MaterialPageRoute(builder: (context) => MainScreen());
      case RegisterScreen.routeName:
        return MaterialPageRoute(builder: (context) => RegisterScreen());
      case LoginScreen.routeName:
        return MaterialPageRoute(builder: (context) => LoginScreen());
      case Home.routeName:
        return MaterialPageRoute(builder: (context) => Home());
      case Chatbot.routeName:
        return MaterialPageRoute(builder: (context) => Chatbot());
    }
  }
}