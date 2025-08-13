import 'package:flutter/material.dart';
import 'model.dart';


typedef RemoveFromCartCallback = void Function(CartItem item);


class CartPage extends StatefulWidget {
  final List<CartItem> cartItems;
  final int cartTotal;
  final RemoveFromCartCallback? onRemove;

  const CartPage({Key? key, required this.cartItems, required this.cartTotal, this.onRemove}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late List<CartItem> _cartItems;

  @override
  void initState() {
    super.initState();
    _cartItems = List<CartItem>.from(widget.cartItems);
  }

  void _removeItem(CartItem item) {
    setState(() {
      _cartItems.remove(item);
    });
    if (widget.onRemove != null) {
      widget.onRemove!(item);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    int cartTotal = _cartItems.fold(0, (sum, item) => sum + (item.dish.price * item.quantity));

    return Scaffold(
      appBar: AppBar(
        title: const Text('ตะกร้าของคุณ'),
        backgroundColor: Colors.orange,
      ),
      body: SafeArea(
        child: _cartItems.isEmpty
            ? const Center(child: Text('ยังไม่มีสินค้าในตะกร้า'))
            : ListView.builder(
                padding: EdgeInsets.symmetric(vertical: height * 0.01),
                itemCount: _cartItems.length,
                itemBuilder: (context, i) {
                  final item = _cartItems[i];
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
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.04,
                        vertical: height * 0.015,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          item.dish.image.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    item.dish.image,
                                    width: width * 0.13,
                                    height: width * 0.13,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Icon(Icons.fastfood, size: 40, color: Colors.orange),
                          SizedBox(width: width * 0.04),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.dish.name,
                                  style: TextStyle(
                                    fontSize: width * 0.048,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  item.restaurant.name,
                                  style: TextStyle(
                                    fontSize: width * 0.036,
                                    color: Colors.black54,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: width * 0.02),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('฿${item.dish.price} x ${item.quantity}',
                                  style: TextStyle(
                                    fontSize: width * 0.038,
                                    color: Colors.grey[800],
                                  )),
                              SizedBox(height: 4),
                              Text('รวม: ฿${item.dish.price * item.quantity}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: width * 0.04,
                                    color: Colors.orange,
                                  )),
                              SizedBox(height: 8),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red, size: 22),
                                tooltip: 'ลบรายการนี้',
                                onPressed: () => _removeItem(item),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      backgroundColor: Colors.grey.shade100,
      bottomNavigationBar: _cartItems.isEmpty
          ? null
          : Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey[200]!)),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'รวมทั้งหมด',
                          style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                        ),
                        Text(
                          '฿$cartTotal',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('สั่งซื้อสำเร็จ'),
                              content: Text('ขอบคุณที่ใช้บริการ!'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _cartItems.clear();
                                    });
                                    if (widget.onRemove != null) {
                                      for (final item in List<CartItem>.from(widget.cartItems)) {
                                        widget.onRemove!(item);
                                      }
                                    }
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('ปิด'),
                                ),
                              ],
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'สั่งซื้อ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
