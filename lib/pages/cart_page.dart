import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/cart_model.dart';
import '../services/product_service.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final ProductService _productService = ProductService();

  void _updateQuantity(Product product, int change) {
    setState(() {
      product.quantity += change;
      if (product.quantity <= 0) {
        cart.remove(product);
      }
    });
  }

  Future<void> _createOrder() async {
    try {
      await _productService.createOrder(cart);
      setState(() {
        cart.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заказ успешно создан')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating order: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Корзина'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                final product = cart[index];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text('${product.price} рублей x ${product.quantity}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle),
                        onPressed: () => _updateQuantity(product, -1),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle),
                        onPressed: () => _updateQuantity(product, 1),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _createOrder,
              child: const Text('Создать заказ'),
            ),
          ),
        ],
      ),
    );
  }
}