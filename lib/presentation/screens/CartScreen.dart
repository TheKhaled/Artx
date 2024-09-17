import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/model/product_model.dart';
import 'package:flutter_application_1/globals.dart';
import 'package:flutter_application_1/presentation/screens/Checkout_Page.dart';
import 'package:flutter_application_1/presentation/widgets/Category_Appbar.dart';
import 'package:flutter_application_1/presentation/widgets/Color.dart';
import 'package:flutter_application_1/presentation/widgets/EmptyCard.dart';
import 'package:flutter_application_1/presentation/widgets/Main_Button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    try {
      final response = await http.get(
        Uri.parse("https://art-ecommerce-server.glitch.me/api/cartItems"),
        headers: {
          'Authorization': 'Bearer $authToken', // Add auth token here
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          items = List<Map<String, dynamic>>.from(json.decode(response.body));
        });
      } else {
        throw Exception('Failed to load cart items');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<ProductModel?> fetchProduct(String productId) async {
    final response = await http.get(Uri.parse(
        'https://art-ecommerce-server.glitch.me/api/products/$productId'));

    if (response.statusCode == 200) {
      return ProductModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load product');
    }
  }

  Future<void> updateCartItemQuantity(
      List<Map<String, dynamic>> itemsArr) async {
    try {
      await http.post(
        Uri.parse("https://art-ecommerce-server.glitch.me/api/cartItems"),
        headers: {
          'Authorization': 'Bearer $authToken', // Add auth token here
          'Content-Type': 'application/json',
        },
        body: jsonEncode(itemsArr),
      );
    } catch (e) {
      print('Error: $e');
    }
  }

  void _incrementItem(Map<String, dynamic> item) async {
    // Fetch product stock
    try {
      ProductModel? product = await fetchProduct(item["item"]["_id"]);
      if (product != null && product.stock > item['quantity']) {
        setState(() {
          item['quantity']++;
        });
        List<Map<String, dynamic>> itemsArr = items
            .map((item) => {
                  "productId": item["item"]["_id"],
                  "quantity": item["quantity"]
                })
            .toList();

        updateCartItemQuantity(itemsArr);
      } else {
        // Show Snackbar if there is no stock available
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cannot add more. No more stock available.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _decrementItem(Map<String, dynamic> item) {
    if (item['quantity'] > 1) {
      setState(() {
        item['quantity']--;
      });
      List<Map<String, dynamic>> itemsArr = items
          .map((item) =>
              {"productId": item["item"]["_id"], "quantity": item["quantity"]})
          .toList();

      updateCartItemQuantity(itemsArr);
    }
  }

  void _removeItem(int index) {
    setState(() {
      items.removeAt(index); // Remove item locally
    });

    // Prepare the updated cart for sending to the backend
    List<Map<String, dynamic>> updatedCart = items
        .map((item) =>
            {"productId": item["item"]["_id"], "quantity": item["quantity"]})
        .toList();

    updateCartItemQuantity(updatedCart); // Send updated cart to backend
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Product has been removed.'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    // Define responsive sizes
    double cardHeight = screenHeight * 0.2; // 20% of screen height
    double margin = screenWidth * 0.03; // 3% of screen width
    double padding = screenWidth * 0.04; // 4% of screen width
    double iconSize = screenWidth * 0.05; // 5% of screen width
    double textSize = screenWidth * 0.04; // 4% of screen width

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Cart'),
      body: items.isEmpty
          ? Emptycard()
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Container(
                        margin: EdgeInsets.all(margin),
                        padding: EdgeInsets.all(padding),
                        height: cardHeight,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: theWebColor, width: 0.5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.network(
                                item['item']['image'] ,
                                width:
                                    screenWidth * 0.25, // 25% of screen width
                                height: cardHeight * 0.6, // 60% of card height
                                fit: BoxFit.cover),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['item']['name'],
                                  style: GoogleFonts.openSans(
                                    color: Colors.black,
                                    fontSize: textSize,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(height: padding),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () => _incrementItem(item),
                                      iconSize: iconSize,
                                      color: Colors.black,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: padding / 2),
                                      child: Text(
                                        item['quantity'].toString(),
                                        style: TextStyle(
                                            fontSize: textSize,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.remove),
                                      onPressed: () => _decrementItem(item),
                                      iconSize: iconSize,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.delete_outline),
                                  onPressed: () => _removeItem(index),
                                  iconSize: iconSize,
                                  color: theWebColor,
                                ),
                                SizedBox(
                                    height:
                                        cardHeight * 0.2), // 20% of card height
                                Text(
                                  "\$${item['item']['price'] * item['quantity']}",
                                  style: GoogleFonts.openSans(
                                    color: Colors.black,
                                    fontSize: textSize *
                                        1.1, // Slightly larger text for price
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Column(
                  children: [
                    Divider(color: theWebColor),
                    Padding(
                      padding: EdgeInsets.all(padding),
                      child: Text(
                        "Total Price: \$${items.fold(0, (total, item) => (total + item['item']['price'] * item['quantity']).toInt())}",
                        style: TextStyle(fontSize: textSize),
                      ),
                    ),
                    Divider(color: theWebColor),
                    Main_Button(
                      buttontext: 'Check-Out',
                      color: theWebColor,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CheckoutPage()),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.1), // 10% of screen height
              ],
            ),
    );
  }
}
