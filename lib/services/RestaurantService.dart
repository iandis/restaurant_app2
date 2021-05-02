import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:restaurant_app2/models/Restaurant.dart';

import '../Api.dart';

class RestaurantService extends GetxService{
  final http.Client _client;
  final Map<String, String> _headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
  };

  RestaurantService() : _client = http.Client();

  //I deliberately removed try-catch from these functions 
  //so the controller can catch it and tell the user the error
  Future<RestaurantDetail> getRestaurantDetail(String id) async {
    RestaurantDetail restaurantDetail;

    var uri = Uri.parse(Api.baseEP + Api.getDetailEP + id);
    var response = await _client.get(
      uri,
      headers: _headers,
    );
    if(response.statusCode == 200){
      String body = response.body;
      Map<String, dynamic> map = json.decode(body);
      restaurantDetail = RestaurantDetail.fromMap(map['restaurant']);
    }

    return restaurantDetail;
  }
  
  //I deliberately removed try-catch from these functions 
  //so the controller can catch it and tell the user the error
  Future<List<Restaurant>> getRestaurantList() async{
    List<Restaurant> restaurants;

    var uri = Uri.parse(Api.baseEP + Api.getListEP);
    var response = await _client.get(
      uri,
      headers: _headers,
    );
    if(response.statusCode == 200){
      String body = response.body;
      Map<String, dynamic> map = json.decode(body);
      restaurants = List<Restaurant>.from(map['restaurants']?.map((x) => Restaurant.fromMap(x)));
    }

    return restaurants;
  }

  //I deliberately removed try-catch from these functions 
  //so the controller can catch it and tell the user the error
  Future<List<Restaurant>> searchRestaurant(String keyword) async {
    List<Restaurant> restaurants;

    var uri = Uri.parse(Api.baseEP + Api.getSearchEP + keyword);
    var response = await _client.get(
      uri,
      headers: _headers,
    );
    if(response.statusCode == 200){
      String body = response.body;
      Map<String, dynamic> map = json.decode(body);
      restaurants = List<Restaurant>.from(map['restaurants']?.map((x) => Restaurant.fromMap(x)));
    }

    return restaurants;
  }

}