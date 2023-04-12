class Products {
  final int productId;
  final int id;
  final String image;
  final String name;
  final String description;
  final int price;
  final int quantity;
  final String address;

  const Products({
    required this.productId,
    required this.id,
    required this.image,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.address,
  });

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      productId: json['ProductId'],
      id: json['Id'],
      image: json['Image'],
      name: json['Name'],
      price: json['Price'],
      description: json['Description'],
      quantity: json['Quantity'],
      address: json['address'],
    );
  }
}
