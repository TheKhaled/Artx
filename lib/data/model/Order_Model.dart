class Order {
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final String customerAddress;
  final String paymentMethod;
  final List<OrderItem> orderItems;

  Order({
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.customerAddress,
    required this.paymentMethod,
    required this.orderItems,
    required List<OrderItem> items,
    required String address,
  });

  Map<String, dynamic> toJson() {
    return {
      'customerName': customerName,
      'customerEmail': customerEmail,
      'customerPhone': customerPhone,
      'customerAddress': customerAddress,
      'paymentMethod': paymentMethod,
      'orderItems': orderItems.map((item) => item.toJson()).toList(),
    };
  }
}

class OrderItem {
  final String productName;
  final double productPrice;
  final int productQuantity;
  final String productImageUrl;

  OrderItem({
    required this.productName,
    required this.productPrice,
    required this.productQuantity,
    required this.productImageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'productPrice': productPrice,
      'productQuantity': productQuantity,
      'productImageUrl': productImageUrl,
    };
  }
}
