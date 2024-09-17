class OrderItem {
  final String id;
  final String productName;
  final double productPrice;
  final int productQuantity;
  final String productImageUrl;
  final String orderId;

  OrderItem({
    required this.id,
    required this.productName,
    required this.productPrice,
    required this.productQuantity,
    required this.productImageUrl,
    required this.orderId,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['_id'] as String,
      productName: json['productName'] as String,
      productPrice: (json['productPrice'] as num).toDouble(),
      productQuantity: int.tryParse(json['productQuantity'].toString()) ?? 0,
      productImageUrl: json['productImageUrl'] as String,
      orderId: json['orderId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'productName': productName,
      'productPrice': productPrice,
      'productQuantity': productQuantity,
      'productImageUrl': productImageUrl,
      'orderId': orderId,
    };
  }

  @override
  String toString() {
    return 'OrderItem(id: $id, productName: $productName, productPrice: $productPrice, productQuantity: $productQuantity, productImageUrl: $productImageUrl, orderId: $orderId)';
  }
}

class OrderModel {
  final String id;
  final int orderNumber;
  final String orderStatus;
  final String orderDate;
  final String customerId;
  final String paymentMethod;
  final String profileId;
  final List<OrderItem> orderItems;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.orderStatus,
    required this.orderDate,
    required this.customerId,
    required this.paymentMethod,
    required this.profileId,
    required this.orderItems,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    var orderItemsFromJson = json['orderItems'] as List<dynamic>;
    List<OrderItem> orderItemsList = orderItemsFromJson
        .map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
        .toList();

    return OrderModel(
      id: json['_id'] as String,
      orderNumber: int.tryParse(json['orderNumber'].toString()) ?? 0,
      orderStatus: json['orderStatus'] as String,
      orderDate: json['orderDate'] as String,
      customerId: json['customerId'] as String,
      paymentMethod: json['paymentMethod'] as String,
      profileId: json['profileId'] as String,
      orderItems: orderItemsList,
    );
  }

  static List<OrderModel> listFromJson(List<dynamic> jsonList) {
    return jsonList
        .map((json) => OrderModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'orderNumber': orderNumber,
      'orderStatus': orderStatus,
      'orderDate': orderDate,
      'customerId': customerId,
      'paymentMethod': paymentMethod,
      'profileId': profileId,
      'orderItems': orderItems.map((item) => item.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'OrderModel(id: $id, orderNumber: $orderNumber, orderStatus: $orderStatus, orderDate: $orderDate, customerId: $customerId, paymentMethod: $paymentMethod, profileId: $profileId, orderItems: $orderItems)';
  }

  double getTotalPrice() {
    return orderItems.fold(
        0, (sum, item) => sum + (item.productPrice * item.productQuantity));
  }
}
