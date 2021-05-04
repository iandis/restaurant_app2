
import 'package:get/get.dart';

import '../AppRouter.dart';
import '../controllers/_controllers.dart';
import '../models/Restaurant/Restaurant.dart';
import '../services/_services.dart';

enum FavRestaurantStatus {
  init,
  empty,
  loading,
  loaded,
  error
}

class FavRestaurantController extends GetxController{
  var favRestaurants = RxList<Restaurant>();

  var favRestaurantStatus = (FavRestaurantStatus.init).obs;

  OfflineStorageService offlineStorageService;
  RestaurantDetailController restaurantDetailController;

  @override
  void onInit() {
    offlineStorageService = Get.find();
    restaurantDetailController = Get.find();
    super.onInit();
  }

  ///get fav lists
  void getFavLists() async{
    favRestaurantStatus.value = FavRestaurantStatus.loading;
    try{
      var favs = await offlineStorageService.getFavList();
      if(favs.isEmpty){
        favRestaurantStatus.value = FavRestaurantStatus.empty;
      }else{
        favRestaurants.value = favs;
        favRestaurantStatus.value = FavRestaurantStatus.loaded;
      }
    }catch(e, st){
      print(st);
      print(e);
      favRestaurantStatus.value = FavRestaurantStatus.error;
    }
  }

  ///go to details
  void gotoDetail(String id) async{
    restaurantDetailController.getRestaurant(id, fromFav: true);
    await Get.toNamed(
      AppRoutes.detailScreen,
      arguments: id,
    );
  }

}