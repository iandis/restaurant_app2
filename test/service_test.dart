import 'package:flutter_test/flutter_test.dart';
import '../lib/services/RestaurantService.dart';

void main(){
  
  test('Restaurant service test', () async {
    RestaurantService restaurantService = RestaurantService();

    //var lists = await restaurantService.getRestaurantList();
    await expectLater(await restaurantService.getRestaurantList(), isNot(null));

    //var detail = await restaurantService.getRestaurantDetail('rqdv5juczeskfw1e867');
    await expectLater(await restaurantService.getRestaurantDetail('rqdv5juczeskfw1e867'), isNot(null));

    //var search = await restaurantService.searchRestaurant('Kafe');
    await expectLater(await restaurantService.searchRestaurant('Kafe'), isNot(null));
  });
}