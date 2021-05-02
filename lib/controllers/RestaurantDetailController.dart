
import 'package:get/get.dart';
import 'package:restaurant_app2/models/Restaurant.dart';
import '../services/RestaurantService.dart';

enum RestaurantDetailStatus{
  init,
  loading,
  loaded,
  error
}

class RestaurantDetailController extends GetxController{
  var restaurantDetail = RestaurantDetail().obs;

  var restaurantDetailStatus = (RestaurantDetailStatus.init).obs;

  RestaurantService restaurantService;

  @override
  void onInit() {
    restaurantService = Get.find();
    super.onInit();
  }

  //unload detail
  void clearDetail(){
    restaurantDetailStatus.value = RestaurantDetailStatus.init;
    restaurantDetail.value = RestaurantDetail();
  }

  //get restaurant detail
  void getRestaurant(String id) async{
    restaurantDetailStatus.value = RestaurantDetailStatus.loading;
    try{
      restaurantDetail.value = await restaurantService.getRestaurantDetail(id);
      restaurantDetailStatus.value = RestaurantDetailStatus.loaded;
    }catch(e, st){
      print(st);
      print(e);
      restaurantDetailStatus.value = RestaurantDetailStatus.error;
    }
  }
}