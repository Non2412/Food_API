class Restaurant {
  final int id;
  final String name;
  final String cuisine;
  final double rating;
  final String deliveryTime;
  final int deliveryFee;
  final String image;
  final bool popular;
  final List<Dish> dishes;
  final String country; // เพิ่ม country field

  Restaurant({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.rating,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.image,
    required this.popular,
    required this.dishes,
    required this.country,
  });
}

class Dish {
  final String name;
  final int price;
  final String image;
  final String description;

  Dish({
    required this.name,
    required this.price,
    required this.image,
    this.description = '',
  });
}

class CartItem {
  final Restaurant restaurant;
  final Dish dish;
  int quantity;

  CartItem({
    required this.restaurant,
    required this.dish,
    this.quantity = 1,
  });
}
