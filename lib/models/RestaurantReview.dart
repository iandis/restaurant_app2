part of 'Restaurant.dart';

class RestaurantReview {
  String name;
  String review;
  String date;
  RestaurantReview({
    this.name,
    this.review,
    this.date,
  });

  RestaurantReview copyWith({
    String name,
    String review,
    String date,
  }) {
    return RestaurantReview(
      name: name ?? this.name,
      review: review ?? this.review,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'review': review,
      'date': date,
    };
  }

  factory RestaurantReview.fromMap(Map<String, dynamic> map) {
    return RestaurantReview(
      name: map['name'],
      review: map['review'],
      date: map['date'],
    );
  }

  String toJson() => json.encode(toMap());

  factory RestaurantReview.fromJson(String source) => RestaurantReview.fromMap(json.decode(source));

  @override
  String toString() => 'RestaurantReview(name: $name, review: $review, date: $date)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is RestaurantReview &&
      other.name == name &&
      other.review == review &&
      other.date == date;
  }

  @override
  int get hashCode => name.hashCode ^ review.hashCode ^ date.hashCode;
}
