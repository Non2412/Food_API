import 'package:flutter/material.dart';
import 'model.dart';
import 'category_detail.dart';

class FavoritePage extends StatelessWidget {
  final List<Restaurant> favoriteRestaurants;

  const FavoritePage({Key? key, required this.favoriteRestaurants}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('รายการโปรด'),
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
      ),
      body: SafeArea(
        child: favoriteRestaurants.isEmpty
            ? const Center(child: Text('ยังไม่มีร้านโปรด'))
            : ListView.builder(
                padding: EdgeInsets.symmetric(vertical: height * 0.01),
                itemCount: favoriteRestaurants.length,
                itemBuilder: (context, i) {
                  final r = favoriteRestaurants[i];
                  return Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: width * 0.04,
                      vertical: height * 0.006,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: width * 0.04,
                        vertical: height * 0.015,
                      ),
                      leading: r.image.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                r.image,
                                width: width * 0.13,
                                height: width * 0.13,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(Icons.restaurant, size: 40, color: Colors.orange),
                      title: Text(
                        r.name,
                        style: TextStyle(
                          fontSize: width * 0.048,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        '${r.country} • ${r.cuisine}',
                        style: TextStyle(
                          fontSize: width * 0.036,
                          color: Colors.black54,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
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
                    ),
                  );
                },
              ),
      ),
      backgroundColor: Colors.grey.shade100,
    );
  }
}
