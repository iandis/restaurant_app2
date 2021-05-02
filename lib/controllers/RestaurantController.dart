
import 'package:get/get.dart';

import '../models/Restaurant.dart';
import '../services/RestaurantService.dart';

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
  
  RestaurantService restaurantService;

  @override
  void onInit() {
    restaurantService = Get.find();
    super.onInit();
  }

  //get restaurant lists
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
    if(keyword.isEmpty)//{
      //getLists();
      return;
    //}
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
  
}