import 'package:flutter/material.dart';
import 'model.dart';
import 'category_detail.dart';

class FavoritePage extends StatelessWidget {
  final List<Restaurant> favoriteRestaurants;

  const FavoritePage({Key? key, required this.favoriteRestaurants}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายการโปรด'),
        backgroundColor: Colors.orange,
        leading: BackButton(color: Colors.white),
      ),
      body: favoriteRestaurants.isEmpty
          ? const Center(child: Text('ยังไม่มีร้านโปรด'))
          : ListView.builder(
              itemCount: favoriteRestaurants.length,
              itemBuilder: (context, i) {
                final r = favoriteRestaurants[i];
                return ListTile(
                  leading: r.image.isNotEmpty
                      ? Image.network(r.image, width: 50, height: 50, fit: BoxFit.cover)
                      : const Icon(Icons.restaurant),
                  title: Text(r.name),
                  subtitle: Text('${r.country} • ${r.cuisine}'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.orange),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CategoryDetailPage(
                          country: r.country,
                          dishes: r.dishes.map((d) => d.name).toList(),
                          restaurant: r,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
