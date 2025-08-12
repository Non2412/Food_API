import 'package:flutter/material.dart';
import 'package:food_api/model.dart';
import 'category_detail.dart';

class SearchPage extends StatefulWidget {
  final List<Restaurant> restaurants;

  const SearchPage({super.key, required this.restaurants});

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  List<Restaurant> filteredRestaurants = [];
  List<String> filteredDishes = [];
  bool isSearching = false;
  
  // การค้นหาล่าสุดที่จะถูกบันทึกจริงๆ
  List<String> recentSearches = [];

  // 🎨 Color scheme - โทนส้ม+ขาว
  static const Color primaryOrange = Color(0xFFFF9800); // ส้มหลัก
  static const Color lightOrange = Color(0xFFFFE0B2);   // ส้มอ่อน
  static const Color darkOrange = Color(0xFFF57C00);    // ส้มเข้ม
  static const Color backgroundColor = Colors.white;    // พื้นหลังขาว

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      searchQuery = _searchController.text;
      _performSearch();
    });
  }

  void _performSearch() {
    if (searchQuery.isEmpty) {
      setState(() {
        filteredRestaurants = [];
        filteredDishes = [];
        isSearching = false;
      });
      return;
    }

    setState(() {
      isSearching = true;
    });

    // ค้นหาร้านอาหาร
    filteredRestaurants = widget.restaurants.where((restaurant) {
      return restaurant.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
             restaurant.cuisine.toLowerCase().contains(searchQuery.toLowerCase()) ||
             restaurant.country.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    // ค้นหาเมนูอาหาร
    Set<String> dishSet = {};
    for (var restaurant in widget.restaurants) {
      for (var dish in restaurant.dishes) {
        if (dish.name.toLowerCase().contains(searchQuery.toLowerCase())) {
          dishSet.add(dish.name);
        }
      }
    }
    filteredDishes = dishSet.toList();

    // บันทึกการค้นหาล่าสุด
    if (searchQuery.length >= 2 && !recentSearches.contains(searchQuery)) {
      setState(() {
        recentSearches.insert(0, searchQuery);
        if (recentSearches.length > 5) {
          recentSearches = recentSearches.take(5).toList();
        }
      });
    }

    setState(() {
      isSearching = false;
    });
  }

  void _selectSearchSuggestion(String suggestion) {
    _searchController.text = suggestion;
    searchQuery = suggestion;
    _performSearch();
  }

  void _removeRecentSearch(String search) {
    setState(() {
      recentSearches.remove(search);
    });
  }

  // ค้นหาตามหมวดหมู่ประเทศ
  void _searchByCountry(String country) {
    _searchController.text = country;
    searchQuery = country;
    _performSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header พร้อมช่องค้นหา
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: primaryOrange.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // ปุ่มย้อนกลับ
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: lightOrange,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: primaryOrange.withOpacity(0.2)),
                      ),
                      child: Icon(Icons.arrow_back, color: primaryOrange, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // ช่องค้นหา
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: primaryOrange.withOpacity(0.3)),
                      ),
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        style: TextStyle(color: Colors.grey[800], fontSize: 16),
                        decoration: InputDecoration(
                          hintText: 'ค้นหาร้านอาหาร เมนู...',
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          prefixIcon: Icon(Icons.search, color: primaryOrange),
                          suffixIcon: searchQuery.isNotEmpty
                              ? GestureDetector(
                                  onTap: () {
                                    _searchController.clear();
                                    setState(() {
                                      searchQuery = '';
                                      filteredRestaurants = [];
                                      filteredDishes = [];
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: primaryOrange.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(Icons.clear, color: primaryOrange, size: 18),
                                  ),
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // เนื้อหาหลัก
            Expanded(
              child: searchQuery.isEmpty ? _buildSearchSuggestions() : _buildSearchResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSuggestions() {
    // จัดกลุ่มร้านอาหารตามประเทศ
    Map<String, List<Restaurant>> restaurantsByCountry = {};
    for (var restaurant in widget.restaurants) {
      if (!restaurantsByCountry.containsKey(restaurant.country)) {
        restaurantsByCountry[restaurant.country] = [];
      }
      restaurantsByCountry[restaurant.country]!.add(restaurant);
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // ค้นหาล่าสุด
        if (recentSearches.isNotEmpty) ...[
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: lightOrange,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.history, color: primaryOrange, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'ค้นหาล่าสุด',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: recentSearches.map((search) => _buildSearchChip(search, Icons.history, true)).toList(),
          ),
          const SizedBox(height: 28),
        ],

        // ค้นหาตามหมวดหมู่ประเทศ
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: lightOrange,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.category, color: primaryOrange, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              'ค้นหาตามหมวดหมู่',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 2.2,
          children: restaurantsByCountry.entries.map((entry) {
            return _buildCategoryCard(entry.key, _getCountryIcon(entry.key), entry.value.length);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSearchChip(String text, IconData icon, bool canRemove) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: primaryOrange.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: primaryOrange.withValues(alpha: 0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => _selectSearchSuggestion(text),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 16, color: primaryOrange),
                const SizedBox(width: 8),
                Text(
                  text,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (canRemove) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _removeRecentSearch(text),
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: primaryOrange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.close,
                  size: 14,
                  color: primaryOrange,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String category, String icon, int restaurantCount) {
    return GestureDetector(
      onTap: () => _searchByCountry(category),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              lightOrange.withValues(alpha: 0.3),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: primaryOrange.withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(
              color: primaryOrange.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(icon, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'อาหาร$category',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                      fontSize: 15,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: primaryOrange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$restaurantCount ร้าน',
                style: TextStyle(
                  color: primaryOrange,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCountryIcon(String country) {
    switch (country) {
      case 'ไทย':
        return '🇹🇭';
      case 'ญี่ปุ่น':
        return '🇯🇵';
      case 'อิตาลี':
        return '🇮🇹';
      case 'อเมริกัน':
        return '🇺🇸';
      case 'เอเชีย':
        return '🌏';
      case 'อินเดีย':
        return '🇮🇳';
      case 'เกาหลี':
        return '🇰🇷';
      default:
        return '🍽️';
    }
  }

  Widget _buildSearchResults() {
    if (isSearching) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: lightOrange,
                borderRadius: BorderRadius.circular(20),
              ),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(primaryOrange),
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'กำลังค้นหา...',
              style: TextStyle(
                color: primaryOrange,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    if (filteredRestaurants.isEmpty && filteredDishes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: lightOrange,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(Icons.search_off, size: 64, color: primaryOrange),
            ),
            const SizedBox(height: 20),
            Text(
              'ไม่พบผลการค้นหา',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'ลองเปลี่ยนคำค้นหาใหม่',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // แสดงผลร้านอาหาร
        if (filteredRestaurants.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryOrange, darkOrange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.restaurant, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  'ร้านอาหาร (${filteredRestaurants.length})',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...filteredRestaurants.map((restaurant) => _buildRestaurantCard(restaurant)),
          const SizedBox(height: 24),
        ],

        // แสดงผลเมนูอาหาร
        if (filteredDishes.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryOrange, darkOrange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.food_bank, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  'เมนูอาหาร (${filteredDishes.length})',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...filteredDishes.map((dish) => _buildDishCard(dish)),
        ],
      ],
    );
  }

  Widget _buildRestaurantCard(Restaurant restaurant) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryOrange.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: primaryOrange.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [lightOrange, primaryOrange.withValues(alpha: 0.3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: restaurant.image.isNotEmpty
                ? Image.network(
                    restaurant.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => 
                        const Center(child: Text('🍽️', style: TextStyle(fontSize: 24))),
                  )
                : const Center(child: Text('🍽️', style: TextStyle(fontSize: 24))),
          ),
        ),
        title: Text(
          restaurant.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '${restaurant.country} • ${restaurant.cuisine}',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: lightOrange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: primaryOrange, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '${restaurant.rating}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryOrange,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.access_time, color: Colors.grey[600], size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '${restaurant.deliveryTime.split('-')[0]} นาที',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () {
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
      ),
    );
  }

  Widget _buildDishCard(String dishName) {
    // หาร้านที่มีเมนูนี้
    Restaurant? restaurant;
    for (var r in widget.restaurants) {
      if (r.dishes.any((dish) => dish.name == dishName)) {
        restaurant = r;
        break;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryOrange.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: primaryOrange.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [lightOrange, primaryOrange.withValues(alpha: 0.3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Text('🍽️', style: TextStyle(fontSize: 24)),
          ),
        ),
        title: Text(
          dishName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            restaurant != null ? 'จาก ${restaurant.name}' : 'เมนูอาหาร',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryOrange, darkOrange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: primaryOrange.withValues(alpha: 0.3),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Text(
            'สั่งเลย',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onTap: () {
          if (restaurant != null) {
            List<String> dishNames = restaurant.dishes.map((dish) => dish.name).toList();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoryDetailPage(
                  country: restaurant!.country,
                  dishes: dishNames,
                  restaurant: restaurant,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}