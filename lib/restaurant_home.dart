import 'package:flutter/material.dart';
import 'category_detail.dart';

class RestaurantHomePage extends StatelessWidget {
  RestaurantHomePage({Key? key}) : super(key: key);

  final Map<String, List<String>> menuByCountry = {
    'ไทย': ['ต้มยำกุ้ง', 'ผัดไทย', 'แกงเขียวหวาน'],
    'ญี่ปุ่น': ['ซูชิ', 'ราเมง', 'ทงคัตสึ'],
    'อิตาลี': ['พิซซ่า', 'สปาเกตตี', 'ลาซานญ่า'],
    'อินเดีย': ['แกงกะหรี่', 'นาน', 'บีร์ยานี'],
  };


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เมนูอาหารตามประเทศ'),
        backgroundColor: Colors.orange,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: menuByCountry.keys.length,
        itemBuilder: (context, index) {
          final country = menuByCountry.keys.elementAt(index);
          final dishes = menuByCountry[country]!;

          return Card(
            child: ListTile(
              leading: const Icon(Icons.restaurant_menu),
              title: Text(country),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryDetailPage(
                      country: country,
                      dishes: dishes,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
