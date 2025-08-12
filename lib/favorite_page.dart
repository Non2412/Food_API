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
        backgroundColor: Colors.blueGrey[700],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // ✅ เปลี่ยนให้ย้อนกลับ 1 หน้า
          },
        ),
      ),
      body: SafeArea(
        child: favoriteRestaurants.isEmpty
            ? const Center(child: Text('ยังไม่มีร้านโปรด'))
            : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8), // ✅ ใช้ค่า fix จะดูสม่ำเสมอ
                itemCount: favoriteRestaurants.length,
                itemBuilder: (context, i) {
                  final r = favoriteRestaurants[i];
                  return Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: width * 0.04,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.15),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: width * 0.04,
                        vertical: 8,
                      ),
                      leading: r.image.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                r.image,
                                width: width * 0.13,
                                height: width * 0.13,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Icon(
                                  Icons.broken_image,
                                  size: width * 0.13,
                                  color: Colors.grey,
                                ), // ✅ ป้องกัน error โหลดรูปไม่ขึ้น
                              ),
                            )
                          : const Icon(Icons.restaurant, size: 40, color: Colors.blueGrey),
                      title: Text(
                        r.name,
                        style: TextStyle(
                          fontSize: width * 0.048,
                          fontWeight: FontWeight.w600,
                          color: Colors.blueGrey[900],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        '${r.country} • ${r.cuisine}',
                        style: TextStyle(
                          fontSize: width * 0.036,
                          color: Colors.blueGrey[600],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.blueGrey),
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
