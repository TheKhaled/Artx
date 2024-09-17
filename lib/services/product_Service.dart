import 'dart:convert';
import 'package:flutter_application_1/data/model/product_model.dart';
import 'package:http/http.dart' as http;

class ProductService {
  final String apiUrl = 'https://art-ecommerce-server.glitch.me/api/products';

  Future<List<ProductModel>> fetchProducts() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
