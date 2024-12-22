class Product {
  int? id;
  final String name;
  final String description;
  final String image;
  final double price;
  final String brand;
  final String processor;
  final String ram;
  final String storage;
  final String display;
  final int article;
  bool isFavorite;
  int quantity;

  Product({
    this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.brand,
    required this.processor,
    required this.ram,
    required this.storage,
    required this.display,
    required this.article,
    this.isFavorite = false,
    this.quantity = 1,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: json['image_url'],
      price: (json['price'] as num).toDouble(),
      brand: json['brand'],
      processor: json['processor'],
      ram: json['ram'],
      storage: json['storage'],
      display: json['display'],
      article: json['article'],
      isFavorite: json['is_favorite'],
      quantity: 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'image_url': image,
      'price': price,
      'brand': brand,
      'processor': processor,
      'ram': ram,
      'storage': storage,
      'display': display,
      'article': article,
      'is_favorite': isFavorite,
    };
  }
}