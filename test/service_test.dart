import 'package:flutter_test/flutter_test.dart';
import '../lib/services/RestaurantService.dart';

void main(){
  
  test('Restaurant service test', () async {
    RestaurantService restaurantService = RestaurantService();

    await expectLater(await restaurantService.getRestaurantList(), isNot(null));

    await expectLater(await restaurantService.getRestaurantDetail('rqdv5juczeskfw1e867'), isNot(null));

    await expectLater(await restaurantService.searchRestaurant('Kafe'), isNot(null));
  });
}