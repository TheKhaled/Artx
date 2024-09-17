import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/model/Order_history_model.dart';
import 'package:flutter_application_1/presentation/widgets/Category_Appbar.dart';
import 'package:flutter_application_1/presentation/widgets/Color.dart';
import 'package:google_fonts/google_fonts.dart';

class OneitemhistoryScreen extends StatelessWidget {
  final OrderModel order;

  const OneitemhistoryScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;

    return Scaffold(
      appBar: CustomAppBar(title: 'Details'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: theWebColor, width: 2.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.all(screenWidth * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Order Number: ${order.orderNumber}',
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenWidth * 0.02),
                    Text(
                      'Order Date: ${order.orderDate}',
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                    SizedBox(height: screenWidth * 0.02),
                    Text(
                      'Payment Method: ${order.paymentMethod}',
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: screenWidth * 0.02),
                    Text(
                      'Total Price: ${order.getTotalPrice()}',
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: screenWidth * 0.02),
                    Text(
                      'Order Status: ${order.orderStatus}',
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: order.orderItems.length,
              itemBuilder: (context, index) {
                final item = order.orderItems[index];
                return Container(
                  margin: EdgeInsets.all(screenWidth * 0.03),
                  padding: EdgeInsets.all(screenWidth * 0.03),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: theWebColor, width: 0.5),
                  ),
                  child: Row(
                    children: [
                      // Image Container
                      Container(
                        width: screenWidth * 0.3,
                        height: screenWidth * 0.3,
                        child: Image.network(
                          item.productImageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.error),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.03),
                      // Column for product details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              item.productName,
                              style: GoogleFonts.openSans(
                                color: Colors.black,
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: screenWidth * 0.02),
                            Text(
                              'Quantity: ${item.productQuantity}',
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: screenWidth * 0.02),
                            Text(
                              'Price: \$${item.productPrice.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: screenWidth * 0.02),
                            Text(
                              'Total Price: \$${(item.productPrice * item.productQuantity).toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
