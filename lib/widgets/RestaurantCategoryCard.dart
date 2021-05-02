
import 'package:flutter/material.dart';

class RestaurantCategoryCard extends StatelessWidget{
  final String category;

  const RestaurantCategoryCard({
      Key key, 
      @required this.category
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.amberAccent[400],
      elevation: 0,
      margin: EdgeInsets.only(right: 10),
      /* shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ), */
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
        child: Center(
          child: Text(
            category,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[900] /* AppColors.getTagTextColor(index) */,
            ),
          ),
        ),
      ),
    );
  }

}