
import 'package:flutter/material.dart';
import 'package:restaurant_app2/screens/_screens.dart';

class AppRoutes{
  static const String listScreen = '/';
  static const String detailScreen = '/detail';
}

class AppRouter{
  static Route onGenerateRoute(RouteSettings settings){
    return MaterialPageRoute(
      builder: (_) {
        switch(settings.name){
          case AppRoutes.detailScreen:
            var id = settings.arguments as String;
            return RestaurantDetailScreen(id: id);
          default:
            return RestaurantListScreen();
        }
      }
    );
  }
}