class Cart {
  final int id;
  final int userId;
  final List<int> products;

  Cart({
    required this.id,
    required this.userId,
    required this.products,
  });

  // Factory method to create a Cart object from JSON
  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      userId: json['user'],
      products: List<int>.from(json['products']),
    );
  }

  // Method to convert a Cart object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': userId,
      'products': products,
    };
  }
}
