import 'package:flutter/material.dart';
import 'package:flutter_application_1/bottomAppBar.dart';
import 'package:flutter_application_1/globals.dart';
import 'package:flutter_application_1/presentation/widgets/Category_Appbar.dart';
import 'package:flutter_application_1/presentation/widgets/Color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  String customerName = '';
  String customerEmail = '';
  String customerPhone = '';
  String customerAddress = '';
  String paymentMethod = 'cash on delivery';
  double deliveryCost = 10.00; // Example delivery cost

  Future<List<Map<String, dynamic>>> fetchCartItems() async {
    final response = await http.get(
      Uri.parse('https://art-ecommerce-server.glitch.me/api/cartItems'),
      headers: {
        'Authorization': 'Bearer $authToken', // Include auth token here
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map<Map<String, dynamic>>((item) {
        return {
          'productName': item['item']['name'],
          'productPrice': item['item']['price'],
          'productQuantity': item['quantity'],
          'productImageUrl': item['item']['image'],
        };
      }).toList();
    } else {
      throw Exception('Failed to load cart items');
    }
  }

  Future<void> placeOrder(List<Map<String, dynamic>> orderItems) async {
    final url = 'https://art-ecommerce-server.glitch.me/api/orders';
    final payload = {
      'customerName': customerName,
      'customerEmail': customerEmail,
      'customerPhone': customerPhone,
      'customerAddress': customerAddress,
      'paymentMethod': paymentMethod,
      'orderItems': orderItems,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $authToken",
        },
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        print('Order placed successfully');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Order placed successfully!'),
        ));

        // Clear the cart once the order is successfully placed
        await clearCart(context, authToken!);
      } else {
        print('Failed to place order');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to place order: ${response.reasonPhrase}'),
        ));
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error placing order'),
      ));
    }
  }

  Future<String?> createStripeSession(
      List<Map<String, dynamic>> orderItems) async {
    final url =
        'https://art-ecommerce-server.glitch.me/api/create-checkout-session';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $authToken", // Include your auth token
        },
        body: json.encode(orderItems), // Send the list of items directly
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        // Debug the response data to understand its structure
        print('Stripe session response: $responseData');
        await clearCart(context, authToken!);

        // Check if the response contains a URL

        return responseData; // Return the session URL
      } else {
        print('Failed to create Stripe session: ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      print('Error creating Stripe session: $e');
      return null;
    }
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> clearCart(BuildContext context, String authToken) async {
    try {
      final response = await http.post(
        Uri.parse("https://art-ecommerce-server.glitch.me/api/cartItems"),
        headers: {
          'Authorization':
              'Bearer $authToken', // Ensure authToken is passed correctly
          'Content-Type': 'application/json',
        },
        body: jsonEncode([]), // Send empty list to clear cart
      );

      if (response.statusCode == 200) {
        // Successful cart clear, navigate back and show confirmation
        print('Cart successfully cleared');
        Navigator.push<void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => MyHomePage(
              title: '',
            ),
          ),
        ); // Return true to indicate success
      } else {
        // Handle backend error (e.g., unauthorized, invalid response, etc.)
        print(
            'Failed to clear cart: ${response.statusCode} - ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to clear cart. Please try again later.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Handle any exceptions
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Check-Out'),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchCartItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: theWebColor,
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No cart items found.'));
          }

          final orderItems = snapshot.data!;
          final totalItems = orderItems.fold<num>(
              0, (sum, item) => sum + item['productQuantity']);
          final totalCost = orderItems.fold<double>(
              0,
              (sum, item) =>
                  sum + (item['productPrice'] * item['productQuantity']));
          final totalPrice = totalCost + deliveryCost;

          return Padding(
            padding: EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  // Order summary
                  Text(
                    "Order Summary",
                    style: GoogleFonts.openSans(
                      color: Colors.black, // Adjust color as needed
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Divider(
                    color: theWebColor,
                    thickness: 1,
                  ),
                  SizedBox(height: 10),
                  // Order summary table
                  Table(
                    columnWidths: {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(1),
                    },
                    children: [
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              "Total Items",
                              style: GoogleFonts.openSans(fontSize: 15),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              "$totalItems",
                              style: GoogleFonts.openSans(fontSize: 15),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              "Cost",
                              style: GoogleFonts.openSans(fontSize: 15),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              "\$$totalCost",
                              style: GoogleFonts.openSans(fontSize: 15),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              "Delivery Cost",
                              style: GoogleFonts.openSans(fontSize: 15),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              "\$${deliveryCost.toStringAsFixed(2)}",
                              style: GoogleFonts.openSans(fontSize: 15),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              "Total Cost",
                              style: GoogleFonts.openSans(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              "\$${(totalCost + deliveryCost).toStringAsFixed(2)}",
                              style: GoogleFonts.openSans(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Divider(
                    color: theWebColor,
                    thickness: 1,
                  ),
                  SizedBox(height: 30),
                  SizedBox(height: 30),
                  // Payment method selection
                  DropdownButtonFormField<String>(
                    value: paymentMethod,
                    items: [
                      DropdownMenuItem(
                          value: 'cash on delivery',
                          child: Text('Cash on Delivery')),
                      DropdownMenuItem(
                          value: 'credit card', child: Text('Credit Card')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        paymentMethod = value!;
                      });
                    },
                  ),
                  SizedBox(height: 30),

                  // Form to collect customer information
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Text(
                          "Shipping Details",
                          style: GoogleFonts.openSans(
                            color: Colors.black, // Adjust color as needed
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Divider(
                          color: theWebColor,
                          thickness: 1,
                        ),
                        TextFormField(
                          decoration:
                              InputDecoration(labelText: 'Customer Name'),
                          onSaved: (value) {
                            customerName = value!;
                          },
                        ),
                        TextFormField(
                            decoration:
                                InputDecoration(labelText: 'Customer Email'),
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (value) {
                              customerEmail = value!;
                            },
                            validator: (value) {
                              // Check if the value is null or empty
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }

                              // Define a regular expression for email validation
                              final emailRegExp = RegExp(
                                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                              );

                              // Check if the email matches the regular expression
                              if (!emailRegExp.hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }

                              return null; // Return null if validation passes
                            }),
                        TextFormField(
                          decoration:
                              InputDecoration(labelText: 'Customer Phone'),
                          keyboardType: TextInputType.phone,
                          onSaved: (value) {
                            customerPhone = value!;
                          },
                          validator: (value) {
                            // Check if the value is null or empty
                            if (value == null || value.isEmpty) {
                              return 'Please enter a phone number';
                            }

                            // Define a regular expression for phone number validation
                            final phoneRegExp = RegExp(
                                r'^\+?[\d\s]{10,15}$'); // Adjust the regex pattern based on your requirements

                            // Check if the phone number matches the regular expression
                            if (!phoneRegExp.hasMatch(value)) {
                              return 'Please enter a valid phone number';
                            }

                            return null; // Return null if validation passes
                          },
                        ),
                        TextFormField(
                          decoration:
                              InputDecoration(labelText: 'Customer Address'),
                          keyboardType: TextInputType.text,
                          onSaved: (value) {
                            customerAddress = value!;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter customer address';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 30),
                        // Place Order button
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();

                              if (paymentMethod == 'cash on delivery') {
                                await placeOrder(orderItems);
                              } else if (paymentMethod == 'credit card') {
                                final sessionUrl =
                                    await createStripeSession(orderItems);
                                if (sessionUrl != null) {
                                  _launchURL(sessionUrl); // Launch payment page
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Failed to create Stripe session')),
                                  );
                                }
                              }
                            }
                          },
                          child: Text('Place Order'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
