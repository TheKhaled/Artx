import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/model/product_model.dart';
import 'package:flutter_application_1/globals.dart';
import 'package:flutter_application_1/presentation/screens/Details_Screen.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class CardProduct extends StatefulWidget {
  final String productName;
  final String productPrice;
  final String productImage;
  final double height;
  final String productId;

  const CardProduct({
    Key? key,
    required this.productName,
    required this.productPrice,
    required this.productImage,
    required this.height,
    required this.productId,
  }) : super(key: key);

  @override
  State<CardProduct> createState() => _CardProductState();
}

class _CardProductState extends State<CardProduct> {
  List<Map<String, dynamic>> items = [];

  Future<void> fetchCartItems() async {
    final url = 'https://art-ecommerce-server.glitch.me/api/cartItems';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> cartData = jsonDecode(response.body);
        setState(() {
          items = cartData.map((cartItem) {
            return {
              "item": cartItem['item'] ?? {},
              "quantity": cartItem['quantity'] ?? 1
            };
          }).toList();
        });
      } else {
        print('Failed to fetch cart items: ${response.body}');
      }
    } catch (e) {
      print('Error while fetching cart items: $e');
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

  Future<void> addToCart(String productId) async {
    await fetchCartItems(); // Ensure we have the latest cart items

    // Fetch product details to check stock
    final product = await fetchProduct(productId);
    if (product == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product not found.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Check if the product is already in the cart
    final existingProduct = items.firstWhere(
        (item) => item["item"]["_id"] == productId,
        orElse: () => {"quantity": 0});

    int existingQuantity = existingProduct["quantity"] ?? 0;
    if (existingQuantity >= product.stock) {
      // Show Snackbar if the quantity in cart is equal or greater than stock
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cannot add more. Only ${product.stock} in stock.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Add to cart if there's enough stock
    if (existingQuantity > 0) {
      // If found, increase the quantity
      setState(() {
        existingProduct["quantity"]++;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Product added to cart.'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ));
    } else {
      // If not found, add the new product
      setState(() {
        items.add({
          "item": {
            "_id": productId,
          },
          "quantity": 1
        });
      });
    }

    // Send only productId and quantity to the backend
    List<Map<String, dynamic>> cartPayload = items.map((item) {
      return {"productId": item["item"]["_id"], "quantity": item["quantity"]};
    }).toList();

    try {
      final response = await http.post(
        Uri.parse('https://art-ecommerce-server.glitch.me/api/cartItems'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode(cartPayload),
      );

      if (response.statusCode == 200) {
        fetchCartItems(); // Refresh the cart with correct structure
      } else {
        print('Failed to add product to cart: ${response.body}');
      }
    } catch (e) {
      print('Error while adding product to cart: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCartItems(); // Fetch cart items on init
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Define responsive text styles
    TextStyle productNameStyle = GoogleFonts.ebGaramond(
      color: Colors.black,
      fontSize: screenWidth * 0.04, // 4% of screen width
      fontWeight: FontWeight.w500,
    );

    TextStyle productPriceStyle = GoogleFonts.openSans(
      color: Colors.black,
      fontSize: screenWidth * 0.035, // 3.5% of screen width
      fontWeight: FontWeight.w300,
    );

    return GestureDetector(
      onTap: () async {
        // Fetch product data
        try {
          ProductModel? product = await fetchProduct(widget.productId);
          if (product != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailsScreen(
                  product: product,
                ),
              ),
            );
          }
        } catch (e) {
          print('Failed to load product: $e');
        }
      },
      child: SizedBox(
        height: widget.height * 1.3,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(screenWidth * 0.03), // 3% of screen width
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: widget.height * 0.7, // Adjust image height
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      screenWidth * 0.03), // 3% of screen width
                  image: DecorationImage(
                    image: NetworkImage(widget.productImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(screenWidth * 0.03), // Adjust padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.productName,
                      style: productNameStyle,
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                        height: screenWidth *
                            0.02), // Adjust space between text widgets
                    Text(
                      widget.productPrice,
                      style: productPriceStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: screenWidth * 0.02,
                    right: screenWidth * 0.02,
                    left: screenWidth * 0.02),
                child: SizedBox(
                  width: double.infinity,
                  height: screenWidth * 0.1, // Adjust button height
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: Color.fromARGB(255, 201, 171, 129),
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            screenWidth * 0.02), // Adjust border radius
                      ),
                    ),
                    onPressed: () {
                      addToCart(widget.productId);
                    },
                    child: Text(
                      "Add to cart",
                      style: GoogleFonts.openSans(
                        color: Colors.black,
                        fontSize: screenWidth * 0.035, // Adjust font size
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
