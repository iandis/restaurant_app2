part of 'Restaurant.dart';

class RestaurantMenus {
  List<String> foods;
  List<String> drinks;

  RestaurantMenus({
    this.foods,
    this.drinks,
  });


  RestaurantMenus copyWith({
    List<String> foods,
    List<String> drinks,
  }) {
    return RestaurantMenus(
      foods: foods ?? this.foods,
      drinks: drinks ?? this.drinks,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'foods': foods,
      'drinks': drinks,
    };
  }

  factory RestaurantMenus.fromMap(Map<String, dynamic> map) {
    var foodsList = map['foods'];
    var foods = List<String>.generate(foodsList.length, (i) => foodsList[i]['name']);

    var drinksList = map['drinks'];
    var drinks = List<String>.generate(drinksList.length, (i) => drinksList[i]['name']);
    return RestaurantMenus(
      foods: foods,
      drinks: drinks,
    );
  }

  String toJson() => json.encode(toMap());

  factory RestaurantMenus.fromJson(String source) => RestaurantMenus.fromMap(json.decode(source));

  @override
  String toString() => 'RestaurantMenus(foods: $foods, drinks: $drinks)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is RestaurantMenus &&
      listEquals(other.foods, foods) &&
      listEquals(other.drinks, drinks);
  }

  @override
  int get hashCode => foods.hashCode ^ drinks.hashCode;
}
