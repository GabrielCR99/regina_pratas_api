import 'dart:convert';

class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final String image;
  final int category;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'image': image,
        'category': category,
      };

  factory Product.fromMap(Map<String, dynamic> map) => Product(
        id: map['id']?.toInt() ?? 0,
        name: map['name'] ?? '',
        description: map['description'] ?? '',
        price: map['price']?.toDouble() ?? 0.0,
        image: map['image'] ?? '',
        category: map['category']?.toInt() ?? 0,
      );

  String toJson() => jsonEncode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(jsonDecode(source));
}
