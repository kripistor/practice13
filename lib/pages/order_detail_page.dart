// lib/pages/order_detail_page.dart
import 'package:flutter/material.dart';
import '../models/order_model.dart';
import 'product_detail.dart';

class OrderDetailPage extends StatelessWidget {
  final Order order;

  const OrderDetailPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Заках #${order.id}'),
      ),
      body: ListView.builder(
        itemCount: order.products.length,
        itemBuilder: (context, index) {
          final product = order.products[index];
          return ListTile(
            title: Text(product.name),
            subtitle: Text('${product.price} рублей'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailPage(product: product),
                ),
              );
            },
          );
        },
      ),
    );
  }
}