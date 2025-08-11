import 'package:flutter/material.dart';

class CategoryDetailPage extends StatelessWidget {
  final String country; // ชื่อประเทศ
  final List<String> dishes; // รายชื่อเมนู

  const CategoryDetailPage({
    Key? key,
    required this.country,
    required this.dishes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เมนูอาหารประเทศ $country'),
        backgroundColor: Colors.orange,
      ),
      body: ListView.builder(
        itemCount: dishes.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: Icon(Icons.fastfood),
              title: Text(dishes[index]),
            ),
          );
        },
      ),
    );
  }
}
