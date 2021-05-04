
import 'package:flutter/material.dart';
import 'package:restaurant_app2/screens/_screens.dart';

class AppRoutes{
  static const String listScreen = '/';
  static const String detailScreen = '/detail';
  static const String favScreen = '/fav';
  static const String testScreen = '/test';
}

class AppRouter{
  static Route onGenerateRoute(RouteSettings settings){
    return MaterialPageRoute(
      builder: (_) {
        switch(settings.name){
          case AppRoutes.detailScreen:
            return RestaurantDetailScreen();
          case AppRoutes.favScreen:
            return FavRestaurantScreen();
          case AppRoutes.testScreen:
            return TestScreen();
          default:
            return RestaurantListScreen();
        }
      }
    );
  }
}