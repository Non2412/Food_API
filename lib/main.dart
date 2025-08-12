import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'login_page.dart';
import 'register_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Delivery App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.grey[50],
        fontFamily: 'Roboto',
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/profile': (context) => const ProfilePage(),
        '/home': (context) => RestaurantHomePage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

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
  });
}

class Dish {
  final String name;
  final int price;
  final String image;

  Dish({
    required this.name,
    required this.price,
    required this.image,
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

class RestaurantHomePage extends StatefulWidget {
  @override
  _RestaurantHomePageState createState() => _RestaurantHomePageState();
}

class _RestaurantHomePageState extends State<RestaurantHomePage> {
  String selectedCategory = 'ทั้งหมด';
  List<CartItem> cartItems = [];
  List<int> favorites = [];

  final List<String> categories = [
    'ทั้งหมด', 'อาหารไทย', 'อาหารญี่ปุ่น', 'อาหารอิตาลี', 'เบเกอรี่', 'เครื่องดื่ม'
  ];

  final List<Restaurant> restaurants = [
    Restaurant(
      id: 1,
      name: 'ครัวคุณยาย',
      cuisine: 'อาหารไทย',
      rating: 4.8,
      deliveryTime: '25-35',
      deliveryFee: 15,
      image: '🍛',
      popular: true,
      dishes: [
        Dish(name: 'ผัดไทย', price: 45, image: '🍜'),
        Dish(name: 'แกงเผ็ด', price: 55, image: '🍲'),
        Dish(name: 'ข้าวผัด', price: 40, image: '🍚'),
      ],
    ),
    Restaurant(
      id: 2,
      name: 'Tokyo Sushi',
      cuisine: 'อาหารญี่ปุ่น',
      rating: 4.9,
      deliveryTime: '30-45',
      deliveryFee: 20,
      image: '🍣',
      popular: false,
      dishes: [
        Dish(name: 'Salmon Set', price: 280, image: '🍣'),
        Dish(name: 'Ramen', price: 180, image: '🍜'),
        Dish(name: 'Tempura', price: 220, image: '🍤'),
      ],
    ),
    Restaurant(
      id: 3,
      name: 'Pizza Corner',
      cuisine: 'อาหารอิตาลี',
      rating: 4.6,
      deliveryTime: '20-30',
      deliveryFee: 25,
      image: '🍕',
      popular: true,
      dishes: [
        Dish(name: 'Margherita Pizza', price: 189, image: '🍕'),
        Dish(name: 'Pasta Carbonara', price: 159, image: '🍝'),
        Dish(name: 'Caesar Salad', price: 129, image: '🥗'),
      ],
    ),
    Restaurant(
      id: 4,
      name: 'Sweet Bakery',
      cuisine: 'เบเกอรี่',
      rating: 4.7,
      deliveryTime: '15-25',
      deliveryFee: 10,
      image: '🧁',
      popular: false,
      dishes: [
        Dish(name: 'Chocolate Cake', price: 89, image: '🍰'),
        Dish(name: 'Croissant', price: 35, image: '🥐'),
        Dish(name: 'Coffee', price: 45, image: '☕'),
      ],
    ),
  ];

  void toggleFavorite(int restaurantId) {
    setState(() {
      if (favorites.contains(restaurantId)) {
        favorites.remove(restaurantId);
      } else {
        favorites.add(restaurantId);
      }
    });
  }

  void addToCart(Restaurant restaurant, Dish dish) {
    setState(() {
      int existingIndex = cartItems.indexWhere(
        (item) => item.dish.name == dish.name && item.restaurant.id == restaurant.id
      );
      
      if (existingIndex >= 0) {
        cartItems[existingIndex].quantity++;
      } else {
        cartItems.add(CartItem(restaurant: restaurant, dish: dish));
      }
    });
  }

  List<Restaurant> get filteredRestaurants {
    if (selectedCategory == 'ทั้งหมด') {
      return restaurants;
    }
    return restaurants.where((r) => r.cuisine == selectedCategory).toList();
  }

  int get cartTotal {
    return cartItems.fold(0, (total, item) => total + (item.dish.price * item.quantity));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            color: Colors.white,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Top Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.location_on, color: Colors.red, size: 16),
                                SizedBox(width: 4),
                                Text('ส่งถึง', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                              ],
                            ),
                            Text(
                              'นครราชสีมา',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            // ปุ่มโปรไฟล์
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                                );
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                margin: EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(Icons.person, color: Colors.orange),
                              ),
                            ),
                            // ปุ่มตะกร้า
                            Stack(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Icon(Icons.shopping_cart, color: Colors.white),
                                ),
                                if (cartItems.isNotEmpty)
                                  Positioned(
                                    right: -2,
                                    top: -2,
                                    child: Container(
                                      padding: EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      constraints: BoxConstraints(minWidth: 20, minHeight: 20),
                                      child: Text(
                                        '${cartItems.length}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'ค้นหาร้านอาหาร เมนู...',
                          prefixIcon: Icon(Icons.search, color: Colors.grey),
                          suffixIcon: Icon(Icons.tune, color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                // Promotional Banner
                Container(
                  margin: EdgeInsets.only(bottom: 24),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.orange[400]!, Colors.red[500]!],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ส่งฟรี! 🎉',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'สั่งขั้นต่ำ 100 บาท',
                              style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14),
                            ),
                            SizedBox(height: 8),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'ใช้โค้ด: FREESHIP',
                                style: TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text('🍔', style: TextStyle(fontSize: 40,)),
                    ],
                  ),
                ),

                // Categories
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'หมวดหมู่',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: categories.map((category) {
                          bool isSelected = selectedCategory == category;
                          return Container(
                            margin: EdgeInsets.only(right: 12),
                            child: GestureDetector(
                              onTap: () => setState(() => selectedCategory = category),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.orange : Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  category,
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : Colors.grey[600],
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 24),

                // Popular Restaurants
                if (filteredRestaurants.where((r) => r.popular).isNotEmpty) ...[
                  Text(
                    'ร้านยอดนิยม ⭐',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 12),
                  ...filteredRestaurants.where((r) => r.popular).map((restaurant) => 
                    _buildPopularRestaurantCard(restaurant)
                  ),
                  SizedBox(height: 24),
                ],

                // All Restaurants
                Text(
                  'ร้านอาหารทั้งหมด',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: filteredRestaurants.length,
                  itemBuilder: (context, index) => _buildRestaurantCard(filteredRestaurants[index]),
                ),
                
                SizedBox(height: 100), // Space for bottom widget
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: cartItems.isNotEmpty ? _buildCartSummary() : _buildBottomNavigation(),
    );
  }

  Widget _buildPopularRestaurantCard(Restaurant restaurant) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange[100]!, Colors.red[100]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(restaurant.image, style: TextStyle(fontSize: 28)),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          restaurant.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.grey[800],
                          ),
                        ),
                        if (restaurant.popular) ...[
                          SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'ยอดนิยม',
                              style: TextStyle(color: Colors.white, fontSize: 10),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      restaurant.cuisine,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.yellow[700], size: 16),
                        SizedBox(width: 4),
                        Text('${restaurant.rating}', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                        SizedBox(width: 16),
                        Icon(Icons.access_time, color: Colors.grey[400], size: 16),
                        SizedBox(width: 4),
                        Text('${restaurant.deliveryTime} นาที', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                        SizedBox(width: 16),
                        Text('ค่าส่ง ${restaurant.deliveryFee} บาท', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => toggleFavorite(restaurant.id),
                child: Icon(
                  favorites.contains(restaurant.id) ? Icons.favorite : Icons.favorite_border,
                  color: favorites.contains(restaurant.id) ? Colors.red : Colors.grey[400],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'เมนูแนะนำ',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 8),
              ...restaurant.dishes.take(2).map((dish) => Container(
                margin: EdgeInsets.only(bottom: 8),
                padding: EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey[200]!, width: 0.5)),
                ),
                child: Row(
                  children: [
                    Text(dish.image, style: TextStyle(fontSize: 18)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dish.name,
                            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[800]),
                          ),
                          Text(
                            '${dish.price} บาท',
                            style: TextStyle(
                              color: Colors.orange[600],
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => addToCart(restaurant, dish),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(Icons.add, color: Colors.white, size: 16),
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantCard(Restaurant restaurant) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange[100]!, Colors.red[100]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(restaurant.image, style: TextStyle(fontSize: 32)),
            ),
          ),
          SizedBox(height: 12),
          Text(
            restaurant.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.grey[800],
            ),
          ),
          Text(
            restaurant.cuisine,
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.star, color: Colors.yellow[700], size: 12),
                  SizedBox(width: 2),
                  Text(
                    '${restaurant.rating}',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.access_time, color: Colors.grey[400], size: 12),
                  SizedBox(width: 2),
                  Text(
                    '${restaurant.deliveryTime.split('-')[0]} นาที',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCartSummary() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${cartItems.length} รายการในตะกร้า',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                Text(
                  '฿$cartTotal',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                'ดูตะกร้า',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBottomNavItem('🏠', 'หน้าแรก', onTap: () {}),
              _buildBottomNavItem('🔍', 'ค้นหา', onTap: () {}),
              _buildBottomNavItem('❤️', 'รายการโปรด', onTap: () {}),
              _buildBottomNavItem('👤', 'โปรไฟล์', onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(String icon, String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: TextStyle(fontSize: 20)),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}