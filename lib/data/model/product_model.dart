// product_model.dart

class ProductModel {
  final String imagePath;
  final String productName;
  final int productPrice;
  final String productDetails;
  final int stock;

  ProductModel({
    required this.imagePath,
    required this.productName,
    required this.productPrice,
    required this.productDetails,
    required this.stock,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      imagePath: json['image'] ??
          'https://img.freepik.com/free-vector/glitch-error-404-page_23-2148105404.jpg',
      productName: json['name'] ?? 'Unknown',
      productPrice: json['price'] ?? '0',
      productDetails: json['description'] ?? 'No details available',
      stock: json['stock'] ?? '0',
    );
  }
}
