import 'package:flutter/material.dart';
import 'package:food_api/model.dart';
import 'search_suggestions.dart';
import 'search_results.dart';

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
  List<String> recentSearches = [];

  // 🎨 Color scheme
  static const Color primaryOrange = Color(0xFFFF9800);
  static const Color lightOrange = Color(0xFFFFE0B2);
  static const Color darkOrange = Color(0xFFF57C00);
  static const Color backgroundColor = Colors.white;

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

    // Filter restaurants
    filteredRestaurants = widget.restaurants.where((restaurant) {
      return restaurant.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
             restaurant.cuisine.toLowerCase().contains(searchQuery.toLowerCase()) ||
             restaurant.country.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    // Filter dishes
    Set<String> dishSet = {};
    for (var restaurant in widget.restaurants) {
      for (var dish in restaurant.dishes) {
        if (dish.name.toLowerCase().contains(searchQuery.toLowerCase())) {
          dishSet.add(dish.name);
        }
      }
    }
    filteredDishes = dishSet.toList();

    // Save recent searches
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
            // Search header
            _buildSearchHeader(),
            // Main content
            Expanded(
              child: searchQuery.isEmpty 
                  ? SearchSuggestions(
                      restaurants: widget.restaurants,
                      recentSearches: recentSearches,
                      onSelectSuggestion: _selectSearchSuggestion,
                      onRemoveRecentSearch: _removeRecentSearch,
                      onSearchByCountry: _searchByCountry,
                      primaryOrange: primaryOrange,
                      lightOrange: lightOrange,
                    )
                  : SearchResults(
                      isSearching: isSearching,
                      filteredRestaurants: filteredRestaurants,
                      filteredDishes: filteredDishes,
                      restaurants: widget.restaurants,
                      primaryOrange: primaryOrange,
                      lightOrange: lightOrange,
                      darkOrange: darkOrange,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Container(
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
          // Back button
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
          // Search field
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
    );
  }
}