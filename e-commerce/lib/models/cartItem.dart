class CartItem {
  final String id;
  final String title;
  final String image;
  final double price;
  final int quantity;
  final String description;
  final String category;
  final double rate;
  final int count;

  CartItem({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
    required this.quantity,
    required this.description,
    required this.category,
    required this.rate,
    required this.count,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'image': image,
    'price': price,
    'quantity': quantity,
    'description': description,
    'category': category,
    'rate': rate,
    'count': count,
  };

  factory CartItem.fromMap(Map<String, dynamic> map) => CartItem(
    id: map['id'],
    title: map['title'],
    image: map['image'],
    price: map['price'],
    quantity: map['quantity'],
    description: map['description'] ?? '',
    category: map['category'] ?? '',
    rate: map['rate']?.toDouble() ?? 0.0,
    count: map['count'] ?? 0,
  );
}
