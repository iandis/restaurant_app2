
import 'package:flutter/material.dart';
import 'package:restaurant_app2/models/Restaurant/Restaurant.dart';

class RestaurantReviewCard extends StatelessWidget{
  final RestaurantReview restaurantReview;

  const RestaurantReviewCard({
    Key key, 
    @required this.restaurantReview
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            //reviewer name
            restaurantReview.name,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          Text(
            //review
            restaurantReview.review ?? '',
            style: TextStyle(
              color: Colors.grey[900],
            ),
          ),
          SizedBox(height: 10,),
          Text(
            //review date
            restaurantReview.date,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12,
            ),
          ),
          Divider(),
        ],
      ),
    );
  }

}