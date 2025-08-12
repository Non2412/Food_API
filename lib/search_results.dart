import 'package:flutter/material.dart';
import 'package:food_api/model.dart';
import 'category_detail.dart';

class SearchResults extends StatelessWidget {
  final bool isSearching;
  final List<Restaurant> filteredRestaurants;
  final List<String> filteredDishes;
  final List<Restaurant> restaurants;
  final Color primaryOrange;
  final Color lightOrange;
  final Color darkOrange;

  const SearchResults({
    super.key,
    required this.isSearching,
    required this.filteredRestaurants,
    required this.filteredDishes,
    required this.restaurants,
    required this.primaryOrange,
    required this.lightOrange,
    required this.darkOrange,
  });

  @override
  Widget build(BuildContext context) {
    if (isSearching) return _buildLoadingIndicator();
    if (filteredRestaurants.isEmpty && filteredDishes.isEmpty) return _buildNoResults();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (filteredRestaurants.isNotEmpty) ...[
          _buildSectionHeader('ร้านอาหาร', Icons.restaurant, filteredRestaurants.length),
          const SizedBox(height: 16),
          ...filteredRestaurants.map((r) => _buildRestaurantCard(r, context)),
          const SizedBox(height: 24),
        ],
        if (filteredDishes.isNotEmpty) ...[
          _buildSectionHeader('เมนูอาหาร', Icons.food_bank, filteredDishes.length),
          const SizedBox(height: 16),
          ...filteredDishes.map((d) => _buildDishCard(d, context)),
        ],
      ],
    );
  }

  Widget _buildLoadingIndicator() {
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

  Widget _buildNoResults() {
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

  Widget _buildSectionHeader(String title, IconData icon, int count) {
    return Container(
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
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Text(
            '$title ($count)',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantCard(Restaurant restaurant, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryOrange.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: primaryOrange.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: _buildRestaurantImage(restaurant),
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
            _buildRestaurantInfo(restaurant),
          ],
        ),
        onTap: () => _navigateToRestaurantDetail(restaurant, context),
      ),
    );
  }

  Widget _buildRestaurantImage(Restaurant restaurant) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [lightOrange, primaryOrange.withOpacity(0.3)],
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
                errorBuilder: (_, __, ___) => 
                  const Center(child: Text('🍽️', style: TextStyle(fontSize: 24))),
              )
            : const Center(child: Text('🍽️', style: TextStyle(fontSize: 24))),
      ),
    );
  }

  Widget _buildRestaurantInfo(Restaurant restaurant) {
    return Row(
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
              Icon(Icons.star, color: primaryOrange, size: 14),
              const SizedBox(width: 4),
              Text(
                '${restaurant.rating}',
                style: TextStyle(
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
    );
  }

  Widget _buildDishCard(String dishName, BuildContext context) {
    Restaurant? restaurant;
    try {
      restaurant = restaurants.firstWhere(
        (r) => r.dishes.any((d) => d.name == dishName),
      );
    } catch (e) {
      restaurant = null;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryOrange.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: primaryOrange.withOpacity(0.1),
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
              colors: [lightOrange, primaryOrange.withOpacity(0.3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(child: Text('🍽️', style: TextStyle(fontSize: 24))),
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
        trailing: _buildOrderButton(),
        onTap: () {
          if (restaurant != null) {
            _navigateToRestaurantDetail(restaurant, context);
          }
        },
      ),
    );
  }

  Widget _buildOrderButton() {
    return Container(
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
            color: primaryOrange.withOpacity(0.3),
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
    );
  }

  void _navigateToRestaurantDetail(Restaurant restaurant, BuildContext context) {
    List<String> dishNames = restaurant.dishes.map((d) => d.name).toList();
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
  }
}