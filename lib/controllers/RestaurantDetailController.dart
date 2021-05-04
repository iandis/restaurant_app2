
import 'package:get/get.dart';

import '../models/Restaurant/Restaurant.dart';
import '../services/_services.dart';

enum RestaurantDetailStatus{
  init,
  loading,
  loaded,
  error
}

class RestaurantDetailController extends GetxController{
  var restaurantDetail = RestaurantDetail().obs;

  var restaurantDetailStatus = (RestaurantDetailStatus.init).obs;
  var fromFavScreen = false.obs;
  var isFav = false.obs;
  var id = ''.obs;

  RestaurantService restaurantService;
  OfflineStorageService offlineStorageService;
  
  @override
  void onInit() {
    restaurantService = Get.find();
    offlineStorageService = Get.find();
    super.onInit();
  }

  ///unload detail
  void clearDetail(){
    restaurantDetailStatus.value = RestaurantDetailStatus.init;
    restaurantDetail.value = RestaurantDetail();
  }

  ///get restaurant detail
  void getRestaurant(String id, {bool fromFav = false}) async{
    this.id.value = id;
    fromFavScreen.value = fromFav;
    restaurantDetailStatus.value = RestaurantDetailStatus.loading;
    try{
      restaurantDetail.value = await restaurantService.getRestaurantDetail(id);
      isFav.value = await offlineStorageService.isFav(restaurantDetail.value.id);
      restaurantDetailStatus.value = RestaurantDetailStatus.loaded;
    }catch(e, st){
      print(st);
      print(e);
      restaurantDetailStatus.value = RestaurantDetailStatus.error;
    }
  }

  ///set fav
  void setFav({bool toFav = true}) async{
    try{
      if(toFav){
        var setfav = await offlineStorageService.insertFav(
          Restaurant.fromMap(restaurantDetail.value.toMap())
        );
        if(setfav){
          isFav.value = true;
        }
      }else{
        var delfav = await offlineStorageService.deleteFav(restaurantDetail.value.id);
        if(delfav){
          isFav.value = false;
        }
      }

    }catch(e, st){
      print(st);
      print(e);
    }
  }
}