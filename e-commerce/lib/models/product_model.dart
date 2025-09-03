class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final double rate;
  final int count;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rate,
    required this.count,
  });

  factory Product.fromFirestore(Map<String, dynamic> data, String docId) {
    return Product(
      id: data['id'] is int ? data['id'] : int.tryParse('${data['id']}') ?? 0,
      title: (data['title'] ?? '').toString(),
      price: (data['price'] is num)
          ? (data['price'] as num).toDouble()
          : double.tryParse('${data['price']}') ?? 0.0,
      description: (data['description'] ?? '').toString(),
      category: (data['category'] ?? '').toString(),
      image: (data['image'] ?? '').toString(),
      rate: (data['rating'] != null && data['rating']['rate'] is num)
          ? (data['rating']['rate'] as num).toDouble()
          : 0.0,
      count: (data['rating'] != null && data['rating']['count'] is int)
          ? data['rating']['count']
          : int.tryParse('${data['rating']?['count']}') ?? 0,
    );
  }
}
