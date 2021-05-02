part of 'Restaurant.dart';

class RestaurantDetail extends Restaurant {
  String address;
  List<String> categories;
  RestaurantMenus menus;
  List<RestaurantReview> customerReviews;

  RestaurantDetail({
    String id,
    String name,
    String city,
    num rating,
    String pictureId,
    String description,
    this.address,
    this.categories,
    this.menus,
    this.customerReviews,
  }) : super(
    id: id,
    name: name,
    city: city,
    rating: rating,
    pictureId: pictureId,
    description: description,
  );

  // String get imageSmall => Api.baseEP + Api.getSmallImageEP + this.pictureId;
  // String get imageMedium => Api.baseEP + Api.getMediumImageEP + this.pictureId;
  // String get imageLarge => Api.baseEP + Api.getLargeImageEP + this.pictureId;

  RestaurantDetail copyWith({
    String id,
    String name,
    String city,
    num rating,
    String pictureId,
    String description,
    String address,
    List<String> categories,
    RestaurantMenus menus,
    List<RestaurantReview> customerReviews,
  }) {
    return RestaurantDetail(
      id: id ?? this.id,
      name: name ?? this.name,
      city: city ?? this.city,
      rating: rating ?? this.rating,
      pictureId: pictureId ?? this.pictureId,
      description: description ?? this.description,
      address: address ?? this.address,
      categories: categories ?? this.categories,
      menus: menus ?? this.menus,
      customerReviews: customerReviews ?? this.customerReviews,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'city': city,
      'rating': rating,
      'pictureId': pictureId,
      'description': description,
      'address': address,
      'categories': categories,
      'menus': menus.toMap(),
      'customerReviews': customerReviews?.map((x) => x.toMap())?.toList(),
    };
  }

  factory RestaurantDetail.fromMap(Map<String, dynamic> map) {
    return RestaurantDetail(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      pictureId: map['pictureId'],
      city: map['city'],
      rating: map['rating'],
      address: map['address'],
      categories: List<String>.from(map['categories']?.map((x) => x['name'])),
      menus: RestaurantMenus.fromMap(map['menus']),
      customerReviews: List<RestaurantReview>.from(map['customerReviews']?.map((x) => RestaurantReview.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory RestaurantDetail.fromJson(String source) => RestaurantDetail.fromMap(json.decode(source));

  @override
  String toString() {
    return 'RestaurantDetail(id: $id, name: $name, description: $description, pictureId: $pictureId, city: $city, rating: $rating, address: $address, categories: $categories, menus: $menus, customerReviews: $customerReviews)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is RestaurantDetail &&
      other.id == id &&
      other.name == name &&
      other.description == description &&
      other.pictureId == pictureId &&
      other.city == city &&
      other.rating == rating &&
      other.address == address &&
      listEquals(other.categories, categories) &&
      other.menus == menus &&
      listEquals(other.customerReviews, customerReviews);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      pictureId.hashCode ^
      city.hashCode ^
      rating.hashCode ^ 
      address.hashCode ^
      categories.hashCode ^
      menus.hashCode ^
      customerReviews.hashCode;
  }
}
