import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/model/Order_history_model.dart';
import 'package:flutter_application_1/presentation/screens/OneItemHistory_Screen.dart';
import 'package:flutter_application_1/presentation/widgets/Category_Appbar.dart';
import 'package:flutter_application_1/presentation/widgets/Color.dart';
import 'package:flutter_application_1/services/order_historyAPi.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({super.key});

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  List<OrderModel> _orders = [];

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    try {
      final orders = await OrderHistoryAPI().getOrders();
      setState(() {
        _orders = orders;
      });
    } catch (e) {
      print("Error fetching orders: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      appBar: CustomAppBar(title: 'Product history'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (int i = 0; i < _orders.length; i++)
              Padding(
                padding: EdgeInsets.all(screenWidth * 0.04),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            OneitemhistoryScreen(order: _orders[i]),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: theWebColor, width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // Changes position of shadow
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OneitemhistoryScreen(order: _orders[i]),
                            ),
                          );
                        },
                        splashColor: Colors.grey.withOpacity(0.3),
                        child: Padding(
                          padding: EdgeInsets.all(screenWidth * 0.04),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              // Order Number (with ellipsis if too long)
                              Text(
                                'Order Number: ${_orders[i].orderNumber}',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow:
                                    TextOverflow.ellipsis, // Prevent overflow
                                maxLines: 1,
                              ),
                              SizedBox(height: screenHeight * 0.01),

                              // Order Date
                              Text(
                                'Order Date: ${_orders[i].orderDate}',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                ),
                                overflow:
                                    TextOverflow.ellipsis, // Prevent overflow
                                maxLines: 1,
                              ),
                              SizedBox(height: screenHeight * 0.01),

                              // Payment Method
                              Text(
                                'Payment Method: ${_orders[i].paymentMethod}',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                  color: Colors.black,
                                ),
                                overflow:
                                    TextOverflow.ellipsis, // Prevent overflow
                                maxLines: 1,
                              ),
                              SizedBox(height: screenHeight * 0.01),

                              // Total Price
                              Text(
                                'Total Price: ${_orders[i].getTotalPrice()}',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                  color: Colors.black,
                                ),
                                overflow:
                                    TextOverflow.ellipsis, // Prevent overflow
                                maxLines: 1,
                              ),
                              SizedBox(height: screenHeight * 0.01),

                              // Order Status
                              Text(
                                'Order Status: ${_orders[i].orderStatus}',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                  color: Colors.black,
                                ),
                                overflow:
                                    TextOverflow.ellipsis, // Prevent overflow
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
