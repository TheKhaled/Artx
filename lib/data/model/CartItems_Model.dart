class Item {
  final String id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final String image;
  final String status;
  final String categoryId;
  final String category;

  Item({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.image,
    required this.status,
    required this.categoryId,
    required this.category,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      stock: json['stock'],
      image: json['image'],
      status: json['status'],
      categoryId: json['categoryId'],
      category: json['category'],
    );
  }
}

class CartItem {
  final Item item;
  final int quantity;

  CartItem({
    required this.item,
    required this.quantity,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      item: Item.fromJson(json['item']),
      quantity: json['quantity'],
    );
  }

  int getTotalItemsInCart(List<CartItem> cartItems) {
    return cartItems.fold(0, (sum, item) => sum + item.quantity);
  }
}
