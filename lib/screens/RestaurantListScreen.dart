
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../AppRouter.dart';
import '../models/Restaurant/Restaurant.dart';
import '../widgets/RestaurantCard.dart';
import '../controllers/RestaurantController.dart';

class RestaurantListScreen extends StatelessWidget{
  final RestaurantController restaurantController;
  final TextEditingController searchTextController;
  final FocusNode searchTextFocusNode;
  RestaurantListScreen() : 
  this.restaurantController = Get.find(),
  searchTextController = TextEditingController(),
  searchTextFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: Get.size.height / 12,
        actions: [
          ///go to fav screen
          goToFavIcon(),
          settingsIcon(),
        ],
        //search bar
        title: TextField(
          focusNode: searchTextFocusNode,
          controller: searchTextController,
          onSubmitted: (text) {
            restaurantController.searchRestaurant(text);
          },
          onEditingComplete: () => searchTextFocusNode.unfocus(),
          maxLines: 1,
          cursorColor: Colors.grey[900],
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            filled: true,
            fillColor: Colors.grey[200],
            hintText: 'Search any restaurant',
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey[300],
                width: 2.0,
              ),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.amber[900],
                width: 2.0,
              ),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            prefixIcon: Icon(
                Icons.search,
                size: 18,
                color: Colors.grey[900],
              ),
            suffixIcon: TextButton(
              child: Icon(
                  Icons.close,
                  size: 18,
                  color: Colors.grey[900],
              ),
              onPressed:() {
                if(searchTextController.text.isNotEmpty){
                  searchTextController.clear();
                  restaurantController.getLists();
                }
                searchTextFocusNode.unfocus();
              },
            ),
          ),
        ),
      ),
      body: GetX<RestaurantController>(
        initState: (state) {
          state.controller.getLists();
          ///goto random restaurant detail when received notification
          state.controller.notificationService
            .configureSelectNotificationSubject((payload) {
              state.controller.gotoRandomRestaurant();
            });
        },
        builder: (controller) {
          switch(controller.restaurantListStatus.value){
            case RestaurantListStatus.empty:
              return _empty();
            case RestaurantListStatus.error:
              return _error(controller.getLists);
            case RestaurantListStatus.loaded:
              return _lists(controller.restaurants);
            default:
              return _loading();
          }
        },
        dispose: (state) {
          searchTextController.dispose();
          searchTextFocusNode.dispose();
          state.dispose();
        },
      )
    );
  }

  Widget settingsIcon(){
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: PopupMenuButton(
        icon: Icon(
          Icons.settings
        ),
        itemBuilder: (_) {
          return List.filled(1, 
            PopupMenuItem(
              child: Row(
                children: [
                  Obx(() => Switch(
                    value: restaurantController.scheduled.value,
                    onChanged: (_) async => await restaurantController.scheduleOrCancelRestaurantNotification(),
                  )),
                  Text('Daily reminder'),
                ],
              ),
            )
          );
        },
      ),
    );
  }

  Widget goToFavIcon(){
    return IconButton(
      icon: Icon(
        Icons.favorite_border
      ),
      color: Colors.grey[900],
      onPressed: () async => await Get.toNamed(AppRoutes.favScreen),
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
            Icons.sentiment_very_dissatisfied,
            size: Get.size.height / 4,
          ),
          Text(
            'Oops the restaurant you\'re looking for seems to not exist :(\n\nTry a different keyword, maybe?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _lists(List<Restaurant> restaurants){
    return RefreshIndicator(
      onRefresh: () async {
        searchTextController.text.isEmpty ?
         restaurantController.getLists() :
         restaurantController.searchRestaurant(searchTextController.text);
        return true;
      },
      child: GridView(
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
          restaurants.length, 
          (i) => Builder(
            builder: (_) {
              var restaurant = restaurants[i];
              return RestaurantCard(
                restaurant: restaurant,
                onPressed: () => restaurantController.gotoDetail(restaurant.id),
              );
            }
          )),
      ),
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
          Icon(
            Icons.sentiment_very_dissatisfied_outlined,
            size: Get.size.height / 3,
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

}