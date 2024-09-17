import 'package:dio/dio.dart';
import 'package:flutter_application_1/data/model/Order_history_model.dart';
import 'package:flutter_application_1/globals.dart';

class OrderHistoryAPI {
  final dio = Dio();

  Future<List<OrderModel>> getOrders() async {
    try {
      final response = await dio.get(
        "https://art-ecommerce-server.glitch.me/api/orders",
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $authToken",
          },
        ),
      );
      final List<OrderModel> orders =
          OrderModel.listFromJson(response.data as List<dynamic>);

      print("the response is ${orders}");
      return orders;
    } catch (e) {
      print("Error occurred: $e");
      rethrow;
    }
  }
}
