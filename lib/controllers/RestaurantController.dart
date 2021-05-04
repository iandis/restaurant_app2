import 'dart:math';

import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import '../AppRouter.dart';
import '../models/_models.dart';
import '../services/_services.dart';
import '_controllers.dart';

enum RestaurantListStatus {
  init,
  empty,
  loading,
  loaded,
  error
}

class RestaurantController extends GetxController{
  var restaurants = RxList<Restaurant>();
  var restaurantListStatus = (RestaurantListStatus.init).obs;
  
  var scheduled = false.obs;
  var isFirstInitScheduled = true.obs;

  RestaurantService restaurantService;
  NotificationService notificationService;
  OfflineStorageService offlineStorageService;
  RestaurantDetailController restaurantDetailController;

  @override
  void onInit() {
    super.onInit();
    restaurantService = Get.find();
    restaurantDetailController = Get.find();
    offlineStorageService = Get.find();
    notificationService = Get.find();
    
    tz.initializeTimeZones();
  }
  @override
  void onReady() async{
    ///must delay for about 1 second to wait for database to initialize
    await Future.delayed(Duration(seconds: 1)).then((value) async => await initIsScheduled());
  }

  Future initIsScheduled() async{
    scheduled.value = await offlineStorageService.isScheduled();
  }

  void gotoRandomRestaurant() {
    var random = Random();
    var randId = random.nextInt(restaurants.length - 1);
    
    gotoDetail(restaurants[randId].id);
  }

  ///set or remove daily reminder at 11:00 AM
  Future<void> scheduleOrCancelRestaurantNotification() async {
    if(scheduled.value){
      scheduled.value = false;
      await offlineStorageService.setSchedule(schedule: false);
      await notificationService.cancelSchedule(1); ///our notif id is 1
      return;
    }
    scheduled.value = true;
    await offlineStorageService.setSchedule();
    
    var notifModel = NotificationModel(
      id: 1,
      title: 'Check this out!',
      body: 'You might like this restaurant ;)',
      payload: 'random restaurant',
    );
    var now = tz.TZDateTime.now(tz.local);

    ///(because tz.local is in GMT so we subtract it by 7)
    var nextSchedule = tz.TZDateTime.local(
        now.year,
        now.month,
        now.day,
        11 - 7 ,
      );
    if(now.hour >= 11 - 7 && now.second >= 0)
      nextSchedule = nextSchedule.add(Duration(days: 1));

    //print(nextSchedule);
    await notificationService.scheduleNotification(
      notificationModel: notifModel, 
      dateTime: nextSchedule,
      daily: true,
    );

  }

  ///get restaurant lists
  void getLists() async{
    restaurantListStatus.value = RestaurantListStatus.loading;
    try{
      restaurants.value = await restaurantService.getRestaurantList();
      restaurantListStatus.value = RestaurantListStatus.loaded;
    }catch(e, st){
      print(st);
      print(e);
      restaurantListStatus.value = RestaurantListStatus.error;
    }
  }

  //search restaurant
  void searchRestaurant(String keyword) async{
    if(keyword.isEmpty)
      return;

    restaurantListStatus.value = RestaurantListStatus.loading;
    try{
      var search = await restaurantService.searchRestaurant(keyword);
      if(search.isEmpty)
        restaurantListStatus.value = RestaurantListStatus.empty;
      else{
        restaurants.value = search;
        restaurantListStatus.value = RestaurantListStatus.loaded;
      }
    }catch(e, st){
      print(st);
      print(e);
      restaurantListStatus.value = RestaurantListStatus.error;
    }
  }

  ///go to details
  void gotoDetail(String id) async{

    restaurantDetailController.getRestaurant(id);
    await Get.toNamed(
      AppRoutes.detailScreen,
      arguments: id,
    );
  }
  
}