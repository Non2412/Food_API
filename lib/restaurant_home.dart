import 'package:flutter/material.dart';
import 'package:food_api/model.dart';
import 'category_detail.dart';

class RestaurantCountryPage extends StatelessWidget {
  final List<Restaurant> restaurants;

  const RestaurantCountryPage({Key? key, required this.restaurants}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // จัดกลุ่มร้านอาหารตามประเทศ
    Map<String, List<Restaurant>> restaurantsByCountry = {};
    for (var restaurant in restaurants) {
      if (!restaurantsByCountry.containsKey(restaurant.country)) {
        restaurantsByCountry[restaurant.country] = [];
      }
      restaurantsByCountry[restaurant.country]!.add(restaurant);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('เมนูอาหารตามประเทศ'),
        backgroundColor: Colors.orange,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.orange.shade50, Colors.white],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: restaurantsByCountry.keys.length,
          itemBuilder: (context, index) {
            final country = restaurantsByCountry.keys.elementAt(index);
            final countryRestaurants = restaurantsByCountry[country]!;
            final dishes = countryRestaurants.expand((r) => r.dishes.map((d) => d.name)).toList();

            // หาไอคอนประเทศ
            String countryIcon = _getCountryIcon(country);
            
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [Colors.white, Colors.grey.shade50],
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        countryIcon,
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                  title: Text(
                    'อาหาร$country',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        '${countryRestaurants.length} ร้าน • ${dishes.length} เมนู',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${_getAverageRating(countryRestaurants).toStringAsFixed(1)}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(Icons.access_time, color: Colors.grey[400], size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${_getAverageDeliveryTime(countryRestaurants)} นาที',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: Container(
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryDetailPage(
                          country: country,
                          dishes: dishes,
                          restaurants: countryRestaurants, restaurant: countryRestaurants.isNotEmpty ? countryRestaurants[0] : Restaurant(
                            id: 0,
                            name: 'ไม่มีข้อมูล',
                            cuisine: '',
                            rating: 0.0,
                            deliveryTime: '0-0',
                            deliveryFee: 0,
                            image: '',
                            popular: false,
                            dishes: [],
                            country: country,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
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
      default:
        return '🍽️';
    }
  }

  double _getAverageRating(List<Restaurant> restaurants) {
    if (restaurants.isEmpty) return 0.0;
    double total = restaurants.fold(0.0, (sum, restaurant) => sum + restaurant.rating);
    return total / restaurants.length;
  }

  String _getAverageDeliveryTime(List<Restaurant> restaurants) {
    if (restaurants.isEmpty) return '0';
    int total = 0;
    int count = 0;
    
    for (var restaurant in restaurants) {
      var times = restaurant.deliveryTime.split('-');
      if (times.isNotEmpty) {
        total += int.tryParse(times[0]) ?? 0;
        count++;
      }
    }
    
    return count > 0 ? (total / count).round().toString() : '0';
  }
}

// หน้าเดิมที่ใช้ข้อมูลคงที่
class RestaurantHomePage extends StatelessWidget {
  const RestaurantHomePage({Key? key}) : super(key: key);

  final Map<String, List<String>> menuByCountry = const {
    'ไทย': ['ต้มยำกุ้ง', 'ผัดไทย', 'แกงเขียวหวาน', 'ส้มตำ', 'มันฟื้ด'],
    'ญี่ปุ่น': ['ซูชิ', 'ราเมง', 'ทงคัตสึ', 'เทมปุระ', 'อุด้ง'],
    'อิตาลี': ['พิซซ่า', 'สปาเกตตี', 'ลาซานญ่า', 'ริซอตโต้', 'เจลาโต้'],
    'อินเดีย': ['แกงกะหรี่', 'นาน', 'บีร์ยานี', 'ทันดูรี', 'ไชน์'],
    'เกาหลี': ['กิมจิ', 'บิบิมบับ', 'บุลโกกิ', 'ทอกบกกิ', 'คิมบับ'],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เมนูอาหารตามประเทศ (ตัวอย่าง)'),
        backgroundColor: Colors.orange,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.orange.shade50, Colors.white],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: menuByCountry.keys.length,
          itemBuilder: (context, index) {
            final country = menuByCountry.keys.elementAt(index);
            final dishes = menuByCountry[country]!;

            String countryIcon = _getStaticCountryIcon(country);
            
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [Colors.white, Colors.grey.shade50],
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        countryIcon,
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                  title: Text(
                    'อาหาร$country',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        '${dishes.length} เมนู',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  trailing: Container(
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryDetailPage(
                          country: country,
                          dishes: dishes, restaurant: Restaurant(
                            id: 0,
                            name: 'ไม่มีข้อมูล',
                            cuisine: '',
                            rating: 0.0,
                            deliveryTime: '0-0',
                            deliveryFee: 0,
                            image: '',
                            popular: false,
                            dishes: [],
                            country: country,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String _getStaticCountryIcon(String country) {
    switch (country) {
      case 'ไทย':
        return '🇹🇭';
      case 'ญี่ปุ่น':
        return '🇯🇵';
      case 'อิตาลี':
        return '🇮🇹';
      case 'อินเดีย':
        return '🇮🇳';
      case 'เกาหลี':
        return '🇰🇷';
      default:
        return '🍽️';
    }
  }
}