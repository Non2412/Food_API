import 'package:flutter/material.dart';
import 'model.dart';

class FavoritePage extends StatelessWidget {
  final List<Restaurant> favoriteRestaurants;

  const FavoritePage({Key? key, required this.favoriteRestaurants}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายการโปรด'),
        backgroundColor: Colors.orange,
      ),
      body: favoriteRestaurants.isEmpty
          ? Center(child: Text('ยังไม่มีร้านโปรด'))
          : ListView.builder(
              itemCount: favoriteRestaurants.length,
              itemBuilder: (context, index) {
                final restaurant = favoriteRestaurants[index];
                return ListTile(
                  leading: restaurant.image.isNotEmpty
                      ? Image.network(restaurant.image, width: 50, height: 50, fit: BoxFit.cover)
                      : Icon(Icons.restaurant),
                  title: Text(restaurant.name),
                  subtitle: Text('${restaurant.country} • ${restaurant.cuisine}'),
                );
              },
            ),
    );
  }
}