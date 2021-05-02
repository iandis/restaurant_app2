
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app2/widgets/RestaurantCategoryCard.dart';
import 'package:restaurant_app2/widgets/_widgets.dart';


import '../models/Restaurant.dart';
import '../controllers/_controllers.dart';

class RestaurantDetailScreen extends StatelessWidget{
  final RestaurantDetailController controller;
  final String id;
  

  RestaurantDetailScreen({ @required this.id }) : controller = Get.find();

  @override
  Widget build(BuildContext context) {
    
    return WillPopScope(
      onWillPop: () async {
        controller.clearDetail();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(),
        body: GetX<RestaurantDetailController>(
          initState: (state) => controller.getRestaurant(id),
          builder: (controller) {
            switch(controller.restaurantDetailStatus.value){
              case RestaurantDetailStatus.error:
                return _error();
              case RestaurantDetailStatus.loaded:
                return _detail(controller.restaurantDetail.value);
              default:
                return _loading();  
            }
          },
        ),
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
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }

  Widget _detail(RestaurantDetail restaurantDetail){
    var isOpens = [false, false].obs;
    var cardWidth = (Get.size.width - 100) / 3;
    return CustomScrollView(
        slivers: [
          //restaurant picture
          SliverToBoxAdapter(
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              height: Get.height / 3.6,
              imageUrl: restaurantDetail.imageMedium,
              placeholder: (_, __) => Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
          //restaurant details
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //restaurant name
                  Text(
                    restaurantDetail.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  //restaurant address
                  Text(
                    restaurantDetail.address + ', ' + restaurantDetail.city,
                    maxLines: 2,
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  //restaurant rating
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 16,
                        color: Colors.yellow[800],
                      ),
                      Text(
                        restaurantDetail.rating.toString(),
                      ),
                    ],
                  ),
                  /* //separator
                  SizedBox(height: 20,),
                  //restaurant description
                  Text(
                    restaurantDetail.description,
                  ), */
                ],
              ),
            ),
          ),
          //restaurant categories
          SliverToBoxAdapter(
            child: Container(
              height: restaurantDetail.categories.length > 0 ? 60 : 0,
              child: ListView.builder(
                primary: false,
                padding: EdgeInsets.all(10),
                scrollDirection: Axis.horizontal,
                itemCount: restaurantDetail.categories.length,
                itemBuilder: (_, i){
                  return RestaurantCategoryCard(
                    category: restaurantDetail.categories[i],
                  );
                },
              ),
            ),
          ),
          //restaurant description
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Text(
                restaurantDetail.description,
              ),
            ),
          ),
          //menus sections
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Obx(() => ExpansionPanelList(
                expansionCallback: (i, isExpanded) {
                  isOpens[i] = !isExpanded;
                }, 
                children: List<ExpansionPanel>.generate(
                  2,
                  (i) {
                    return ExpansionPanel(
                      headerBuilder: (_,__) => ListTile(
                        //food or drink section label
                        title: Text(
                          i == 0 ? 'Foods' : 'Drinks',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      canTapOnHeader: true,
                      isExpanded: isOpens[i],
                      body: Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                        //food or drink cards
                        child: Wrap(
                          direction: Axis.horizontal,
                          spacing: 10,
                          runSpacing: 10,
                          children: List.generate(
                            i == 0 ? 
                              restaurantDetail.menus.foods.length :
                              restaurantDetail.menus.drinks.length, 
                            (j) => Card(
                              margin: EdgeInsets.zero,
                              elevation: 0,
                              color: Colors.amberAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                              ),
                              child: Container(
                                width: cardWidth,
                                height: 60,
                                padding: EdgeInsets.all(5),
                                alignment: Alignment.center,
                                child: Text(
                                  i == 0 ? 
                                    restaurantDetail.menus.foods[j] :
                                    restaurantDetail.menus.drinks[j],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                ),
              ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Text(
                'Reviews',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          //customer reviews
          SliverPadding(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => RestaurantReviewCard(
                  restaurantReview: restaurantDetail.customerReviews[i],
                ),
                childCount: restaurantDetail.customerReviews.length,
                addAutomaticKeepAlives: false,
              ),
            ),
          ),
        ],
      );
  }
}