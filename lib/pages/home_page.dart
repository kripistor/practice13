import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';
import '../services/product_service.dart';
import 'add_product.dart';
import 'edit_product.dart';
import 'product_detail.dart';
import '../models/cart_model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Product>> _futureProducts;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _futureProducts = ProductService().fetchProducts();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _futureProducts = ProductService().fetchProducts(query: _searchQuery);
    });
  }

  void _addToCart(Product product) {
    setState(() {
      final existingProduct = cart.firstWhere(
            (cartProduct) => cartProduct.id == product.id,
        orElse: () => Product(
          id: product.id,
          name: product.name,
          description: product.description,
          image: product.image,
          price: product.price,
          brand: product.brand,
          processor: product.processor,
          ram: product.ram,
          storage: product.storage,
          display: product.display,
          article: product.article,
          quantity: 0,
        ),
      );

      if (existingProduct.quantity == 0) {
        cart.add(existingProduct);
      }
      existingProduct.quantity += 1;
    });
  }

  void _deleteProduct(int id) async {
    try {
      final response = await http.delete(Uri.parse('http://172.19.0.1:8080/products/delete/$id'));
      if (response.statusCode == 204) {
        setState(() {
          _futureProducts = ProductService().fetchProducts();
        });
      } else {
        print('Failed to delete product: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to delete product: $e');
    }
  }

  void _navigateToAddProductPage() async {
    final products = await _futureProducts;
    final newProduct = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddProductPage(products: products),
      ),
    );

    if (newProduct != null) {
      setState(() {
        _futureProducts = ProductService().fetchProducts();
      });
    }
  }

  void _navigateToEditProductPage(Product product) async {
    final updatedProduct = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProductPage(product: product),
      ),
    );

    if (updatedProduct != null) {
      setState(() {
        _futureProducts = ProductService().fetchProducts();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Главная',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Поиск товаров...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<Product>>(
        future: _futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Нет продуктов'));
          } else {
            final products = snapshot.data!;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2 / 3,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: product.image.startsWith('http')
                            ? Image.network(product.image, fit: BoxFit.cover)
                            : Image.asset(product.image, fit: BoxFit.cover),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(product.name, style: Theme.of(context).textTheme.bodyLarge),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: Icon(
                              product.isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: product.isFavorite ? Colors.red : null,
                            ),
                            onPressed: () {
                              setState(() {
                                product.isFavorite = !product.isFavorite;
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _navigateToEditProductPage(product);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _deleteProduct(product.id!);
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: Icon(Icons.add_shopping_cart),
                            onPressed: () => _addToCart(product),
                          ),
                          IconButton(
                            icon: Icon(Icons.arrow_forward),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailPage(product: product),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddProductPage,
        child: Icon(Icons.add),
      ),
    );
  }
}