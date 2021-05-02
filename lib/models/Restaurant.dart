import 'dart:convert';
import 'package:flutter/foundation.dart';

import '../Api.dart';

part 'RestaurantDetail.dart';
part 'RestaurantReview.dart';
part 'RestaurantMenus.dart';

class Restaurant {
  String id;
  String name;
  String description;
  String pictureId;
  String city;
  num rating;

  Restaurant({
    this.id,
    this.name,
    this.description,
    this.pictureId,
    this.city,
    this.rating,
  });

  String get imageSmall => Api.baseEP + Api.getSmallImageEP + this.pictureId;
  String get imageMedium => Api.baseEP + Api.getMediumImageEP + this.pictureId;
  String get imageLarge => Api.baseEP + Api.getLargeImageEP + this.pictureId;

  Restaurant copyWith({
    String id,
    String name,
    String description,
    String pictureId,
    String city,
    num rating,
  }) {
    return Restaurant(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      pictureId: pictureId ?? this.pictureId,
      city: city ?? this.city,
      rating: rating ?? this.rating,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'pictureId': pictureId,
      'city': city,
      'rating': rating,
    };
  }

  factory Restaurant.fromMap(Map<String, dynamic> map) {
    return Restaurant(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      pictureId: map['pictureId'],
      city: map['city'],
      rating: map['rating'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Restaurant.fromJson(String source) => Restaurant.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Restaurant(id: $id, name: $name, description: $description, pictureId: $pictureId, city: $city, rating: $rating)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Restaurant &&
      other.id == id &&
      other.name == name &&
      other.description == description &&
      other.pictureId == pictureId &&
      other.city == city &&
      other.rating == rating;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      pictureId.hashCode ^
      city.hashCode ^
      rating.hashCode;
  }
}
