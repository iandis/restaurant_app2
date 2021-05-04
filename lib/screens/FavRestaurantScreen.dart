
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/_controllers.dart';
import '../widgets/_widgets.dart';

class FavRestaurantScreen extends StatelessWidget{
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: GetX<FavRestaurantController>(
        initState: (state) => state.controller.getFavLists(),
        builder: (controller) {
          switch(controller.favRestaurantStatus.value){
            case FavRestaurantStatus.empty:
              return _empty();
            case FavRestaurantStatus.error:
              return _error(controller.getFavLists);
            case FavRestaurantStatus.loaded:
              return _lists(controller);
            default:
              return _loading();
          }
        },
      ),
    );
  }

  Widget _lists(FavRestaurantController controller){
    return GridView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      addAutomaticKeepAlives: false,
      padding: EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.75,
      ),
      children: List.generate(
        controller.favRestaurants.length, 
        (i) => Builder(
          builder: (_) { 
            var restaurant = controller.favRestaurants[i];
            return RestaurantCard(
              restaurant: restaurant,
              onPressed: () => controller.gotoDetail(restaurant.id),
            );
          }
        )),
    );
  }

  Widget _loading(){
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _error(Function retryCallback){
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Icon(
              Icons.sentiment_very_dissatisfied_outlined,
              size: Get.size.height / 3,
            ),
          ),
          Text(
            'Unknown error occured',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          TextButton(
            onPressed: retryCallback, 
            child: Text(
              'Retry',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
              ),
            )
          ),
        ],
      ),
    );
  }

  Widget _empty(){
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(
            Icons.sentiment_neutral,
            size: Get.size.height / 4,
          ),
          Text(
            'You haven\'t added any favorite restaurant yet. \nTry adding one or two ;)',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

}