
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../AppRouter.dart';
import '../models/Restaurant.dart';
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
        //),
      ),
      body: GetX<RestaurantController>(
        initState: (state) {
          state.controller.getLists();
        },
        builder: (controller) {
          switch(controller.restaurantListStatus.value){
            case RestaurantListStatus.empty:
              return _empty();
            case RestaurantListStatus.error:
              return _error();
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

  Widget _empty(){
    return Center(
      child: Text(
        'Oops the restaurant you\'re looking for seems to not exist :(\nTry a different keyword, maybe?',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
        ),
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
            builder: (_) => 
              RestaurantCard(
                restaurant: restaurants[i],
                onPressed: () async {
                  await Get.toNamed(
                    AppRoutes.detailScreen,
                    arguments: restaurants[i].id,
                  );
                },
              ),
          )),
      ),
    );
  }

  Widget _loading(){
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _error(){
    return Center(
      child: Text(
        'Unknown error occured',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }

}