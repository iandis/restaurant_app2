import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'AppRouter.dart';
import 'controllers/_controllers.dart';
import 'services/_services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, /// transparent status bar
  ));
  runApp(App());
}

class App extends StatelessWidget{
  @override 
  Widget build(BuildContext context){
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
        errorColor: Color(0xffD50000),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        pageTransitionsTheme: PageTransitionsTheme(builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        })
      ),
      ///dependencies
      initialBinding: BindingsBuilder( ()=> {
        Get.put(OfflineStorageService()),
        Get.put(NotificationService()),
        Get.put(RestaurantService()),
        Get.put(RestaurantDetailController()),
        Get.put(RestaurantController()),
        Get.put(FavRestaurantController()),
        Get.put(TestController()),
      }),
      ///routes
      onGenerateRoute: AppRouter.onGenerateRoute,
      ///home
      initialRoute: AppRoutes.listScreen,
    );
  }
}