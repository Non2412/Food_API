import 'package:flutter/material.dart';
import 'package:food_api/model.dart';

class SearchSuggestions extends StatelessWidget {
  final List<Restaurant> restaurants;
  final List<String> recentSearches;
  final Function(String) onSelectSuggestion;
  final Function(String) onRemoveRecentSearch;
  final Function(String) onSearchByCountry;
  final Color primaryOrange;
  final Color lightOrange;

  const SearchSuggestions({
    super.key,
    required this.restaurants,
    required this.recentSearches,
    required this.onSelectSuggestion,
    required this.onRemoveRecentSearch,
    required this.onSearchByCountry,
    required this.primaryOrange,
    required this.lightOrange,
  });

  @override
  Widget build(BuildContext context) {
    // Group restaurants by country
    Map<String, List<Restaurant>> restaurantsByCountry = {};
    for (var restaurant in restaurants) {
      if (!restaurantsByCountry.containsKey(restaurant.country)) {
        restaurantsByCountry[restaurant.country] = [];
      }
      restaurantsByCountry[restaurant.country]!.add(restaurant);
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Recent searches
        if (recentSearches.isNotEmpty) ...[
          _buildSectionHeader(Icons.history, 'ค้นหาล่าสุด'),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: recentSearches.map((search) => _buildSearchChip(search)).toList(),
          ),
          const SizedBox(height: 28),
        ],

        // Search by category
        _buildSectionHeader(Icons.category, 'ค้นหาตามหมวดหมู่'),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 2.2,
          children: restaurantsByCountry.entries.map((entry) {
            return _buildCategoryCard(entry.key, entry.value.length);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: lightOrange,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: primaryOrange, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: primaryOrange.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: primaryOrange.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => onSelectSuggestion(text),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.history, size: 16, color: primaryOrange),
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
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => onRemoveRecentSearch(text),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: primaryOrange.withOpacity(0.1),
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
      ),
    );
  }

  Widget _buildCategoryCard(String category, int restaurantCount) {
    return GestureDetector(
      onTap: () => onSearchByCountry(category),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              lightOrange.withOpacity(0.3),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: primaryOrange.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: primaryOrange.withOpacity(0.1),
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
                Text(_getCountryIcon(category), style: const TextStyle(fontSize: 20)),
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
                color: primaryOrange.withOpacity(0.1),
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
      case 'ไทย': return '🇹🇭';
      case 'ญี่ปุ่น': return '🇯🇵';
      case 'อิตาลี': return '🇮🇹';
      case 'อเมริกัน': return '🇺🇸';
      case 'เอเชีย': return '🌏';
      case 'อินเดีย': return '🇮🇳';
      case 'เกาหลี': return '🇰🇷';
      default: return '🍽️';
    }
  }
}