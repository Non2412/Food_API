import 'package:flutter/material.dart';
import 'package:food_api/model.dart';
import 'category_detail.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  final Color primaryOrange;
  final Color lightOrange;

  const RestaurantCard({
    super.key,
    required this.restaurant,
    required this.primaryOrange,
    required this.lightOrange,
  });

  @override
  Widget build(BuildContext context) {
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
        leading: _buildImage(),
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
            _buildRatingInfo(),
          ],
        ),
        onTap: () => _navigateToDetail(context),
      ),
    );
  }

  Widget _buildImage() {
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

  Widget _buildRatingInfo() {
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

  void _navigateToDetail(BuildContext context) {
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