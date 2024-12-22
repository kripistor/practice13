// lib/models/order_model.dart
import 'product_model.dart';

class Order {
  final int id;
  final List<Product> products;
  final double total;
  final String status;
  final DateTime date;

  Order({
    required this.id,
    required this.products,
    required this.total,
    required this.status,
    required this.date,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      products: (json['products'] as List)
          .map((product) => Product.fromJson(product))
          .toList(),
      total: (json['total'] as num).toDouble(),
      status: json['status'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'products': products.map((product) => product.toJson()).toList(),
      'total': total,
      'status': status,
      'date': date.toIso8601String(),
    };
  }
}