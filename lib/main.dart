import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:food_api/model.dart';
import 'package:http/http.dart' as http;
import 'restaurant_home.dart';
import 'category_detail.dart';
import 'favorite_page.dart'; // <-- นำเข้า FavoritePage


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
      home: RestaurantHomePageData(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class RestaurantHomePageData extends StatefulWidget {
  @override
  _RestaurantHomePageDataState createState() => _RestaurantHomePageDataState();
}

class _RestaurantHomePageDataState extends State<RestaurantHomePageData> {
  String selectedCategory = 'ทั้งหมด';
  List<CartItem> cartItems = [];
  List<int> favorites = [];
  List<Restaurant> restaurants = [];
  bool isLoading = true;
  int selectedTabIndex = 0; // เพิ่มตัวแปรนี้

  final List<String> categories = [
    'ทั้งหมด', 'ไทย', 'ญี่ปุ่น', 'อิตาลี', 'อเมริกัน', 'เอเชีย'
  ];

  // แมปประเทศจาก cuisine
  String mapCuisineToCountry(String cuisine) {
    final Map<String, String> cuisineMap = {
      'Thai': 'ไทย',
      'Japanese': 'ญี่ปุ่น', 
      'Italian': 'อิตาลี',
      'American': 'อเมริกัน',
      'Chinese': 'เอเชีย',
      'Korean': 'เอเชีย',
      'Vietnamese': 'เอเชีย',
      'Indian': 'เอเชีย',
      'Mediterranean': 'อิตาลี',
      'Mexican': 'อเมริกัน',
      'French': 'อิตาลี',
    };
    return cuisineMap[cuisine] ?? 'อื่นๆ';
  }

  @override
  void initState() {
    super.initState();
    fetchRestaurants();
  }

  Future<void> fetchRestaurants() async {
    final url = Uri.parse('https://dummyjson.com/recipes');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List recipes = data['recipes'];

        setState(() {
          restaurants = recipes.map((recipe) {
            String cuisine = recipe['cuisine'] ?? 'Unknown';
            String country = mapCuisineToCountry(cuisine);
            
            return Restaurant(
              id: recipe['id'],
              name: recipe['name'],
              cuisine: cuisine,
              country: country,
              rating: (recipe['rating'] as num).toDouble(),
              deliveryTime:
                  '${(recipe['prepTimeMinutes'] ?? 15)}-${(recipe['cookTimeMinutes'] ?? 30)}',
              deliveryFee: 20,
              image: recipe['image'] ?? '',
              popular: (recipe['rating'] as num) > 4.5,
              dishes: [
                Dish(
                  name: recipe['name'],
                  price: recipe['caloriesPerServing'] ?? 100,
                  image: recipe['image'] ?? '',
                  description: recipe['instructions']?.take(2)?.join(' ') ?? 'อาหารอร่อย',
                )
              ],
            );
          }).toList();
          isLoading = false;
        });
      } else {
        throw Exception('โหลดข้อมูลไม่สำเร็จ');
      }
    } catch (e) {
      print(e);
      setState(() => isLoading = false);
    }
  }

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
          (item) =>
              item.dish.name == dish.name &&
              item.restaurant.id == restaurant.id);

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
    return restaurants.where((r) => r.country == selectedCategory).toList();
  }

  int get cartTotal {
    return cartItems.fold(
        0, (total, item) => total + (item.dish.price * item.quantity));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
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
                                      Icon(Icons.location_on, color: Colors.grey, size: 16),
                                      SizedBox(width: 4),
                                      Text('ส่งถึง', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                                    ],
                                  ),
                                  Text(
                                    'Food Delivery',
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
                                  // ปุ่มดูตามประเทศ
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => RestaurantCountryPage(restaurants: restaurants),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(right: 12),
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Icon(Icons.public, color: Colors.white),
                                    ),
                                  ),
                                  // ปุ่มรายการโปรด
                                  GestureDetector(
                                    onTap: () {
                                      List<Restaurant> favoriteRestaurants = restaurants.where((r) => favorites.contains(r.id)).toList();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => FavoritePage(favoriteRestaurants: favoriteRestaurants),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(right: 12),
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.pink,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Icon(Icons.favorite, color: Colors.white),
                                    ),
                                  ),
                                  // ตะกร้า
                                  Stack(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.orange,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Icon(Icons.shopping_cart,
                                            color: Colors.white),
                                      ),
                                      if (cartItems.isNotEmpty)
                                        Positioned(
                                          right: -2,
                                          top: -2,
                                          child: Container(
                                            padding: EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              color: Colors.red, // เปลี่ยนกลับเป็น Colors.red
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
                                prefixIcon:
                                    Icon(Icons.search, color: Colors.grey),
                                suffixIcon:
                                    Icon(Icons.tune, color: Colors.grey),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
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
                      // Categories
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'หมวดหมู่ประเทศ',
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
                                bool isSelected =
                                    selectedCategory == category;
                                return Container(
                                  margin: EdgeInsets.only(right: 12),
                                  child: GestureDetector(
                                    onTap: () => setState(
                                        () => selectedCategory = category),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Colors.orange // เปลี่ยนกลับเป็น Colors.orange
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.05),
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        category,
                                        style: TextStyle(
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.grey[600],
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.normal,
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
                          childAspectRatio: 0.55, // เพิ่มความสูงของการ์ดมากขึ้นอีก
                        ),
                        itemCount: filteredRestaurants.length,
                        itemBuilder: (context, index) =>
                            _buildRestaurantCard(filteredRestaurants[index]),
                      ),
                      SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
      bottomNavigationBar: cartItems.isNotEmpty
          ? _buildCartSummary()
          : _buildBottomNavigation(),
    );
  }

  Widget _buildRestaurantCard(Restaurant restaurant) {
    return GestureDetector(
      onTap: () {
        // กดดูรายละเอียดของร้าน
        List<String> dishNames = restaurant.dishes.map((dish) => dish.name).toList();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryDetailPage(
              country: restaurant.country,
              dishes: dishNames,
              restaurant: restaurant,
            ),
          ),
        );
      },
      child: Container(
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
          crossAxisAlignment: CrossAxisAlignment.start, // จัดเรียงซ้าย
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 140, // เพิ่มความสูงของรูปภาพมากขึ้นอีก
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: restaurant.image.isNotEmpty
                        ? Image.network(
                            restaurant.image,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: Colors.grey[200],
                            child: Center(
                              child: Text(
                                "🍽️",
                                style: TextStyle(fontSize: 30),
                              ),
                            ),
                          ),
                  ),
                ),
                // ลบ badge "ยอดนิยม" ออก
                // ปุ่มหัวใจ
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => toggleFavorite(restaurant.id),
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        favorites.contains(restaurant.id) 
                            ? Icons.favorite 
                            : Icons.favorite_border,
                        color: favorites.contains(restaurant.id) 
                            ? Colors.pink 
                            : Colors.grey,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            // ชื่อร้าน
            Text(
              restaurant.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.grey[800],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4),
            // ประเภทอาหาร
            Text(
              '${restaurant.country} • ${restaurant.cuisine}',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8),
            // คะแนนและเวลา
            Row(
              children: [
                Icon(Icons.star, color: Colors.orange, size: 14),
                SizedBox(width: 2),
                Text(
                  '${restaurant.rating}',
                  style: TextStyle(
                    fontWeight: FontWeight.w500, 
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.access_time, color: Colors.grey[400], size: 12),
                SizedBox(width: 2),
                Expanded(
                  child: Text(
                    '${restaurant.deliveryTime.split('-')[0]} นาที',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
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
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
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
              _buildBottomNavItem(Icons.home, 'หน้าแรก', 0),
              _buildBottomNavItem(Icons.search, 'ค้นหา', 1),
              _buildBottomNavItem(Icons.favorite, 'รายการโปรด', 2),
              _buildBottomNavItem(Icons.person, 'โปรไฟล์', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(IconData icon, String label, int index) {
    final isSelected = selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTabIndex = index;
        });
        if (label == 'รายการโปรด') {
          List<Restaurant> favoriteRestaurants = restaurants.where((r) => favorites.contains(r.id)).toList();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FavoritePage(favoriteRestaurants: favoriteRestaurants),
            ),
          );
        }
        // เพิ่มการนำทางอื่นๆตามต้องการ
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.orange : Colors.grey[500],
            size: 24,
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.orange : Colors.grey[500],
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}