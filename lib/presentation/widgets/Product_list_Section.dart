import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/screens/All_Products_Page.dart';
import 'package:flutter_application_1/presentation/widgets/Card_Product.dart';
import 'package:flutter_application_1/presentation/widgets/Color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class ProductSection extends StatefulWidget {
  @override
  _ProductSectionState createState() => _ProductSectionState();
}

class _ProductSectionState extends State<ProductSection> {
  List<Map<String, dynamic>> products = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse('https://art-ecommerce-server.glitch.me/api/products'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        // Ensure data is a list of maps
        if (data is List) {
          List<Map<String, dynamic>> parsedProducts = data.map((item) {
            if (item is Map<String, dynamic>) {
              if (item['price'] is int) {
                item['price'] = item['price'].toString();
              }
              return item;
            } else {
              throw Exception('Invalid product format');
            }
          }).toList();

          setState(() {
            products = parsedProducts;
            isLoading = false;
          });
        } else {
          throw Exception('Products data is not a list');
        }
      } else {
        setState(() {
          isLoading = false;
          errorMessage =
              'Failed to load products. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'An error occurred while fetching products.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // "See More" button
        Divider(
          color: theWebColor,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04, // 4% of screen width
            vertical: screenHeight * 0.01, // 1% of screen height
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Products',
                style: GoogleFonts.ebGaramond(
                  fontSize: screenWidth * 0.05, // 5% of screen width
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to product page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProductPage()),
                  );
                },
                child: Text(
                  'See More',
                  style: GoogleFonts.openSans(
                    fontSize: screenWidth * 0.04, // 4% of screen width
                    color: const Color.fromARGB(255, 201, 171, 129),
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(
          color: theWebColor,
        ),
        isLoading
            ? Center(
                child: CircularProgressIndicator(
                color: theWebColor,
              ))
            : errorMessage != null
                ? Center(child: Text(errorMessage!))
                : SizedBox(
                    height: screenHeight * 0.7, // 70% of screen height
                    child: CustomScrollView(
                      slivers: [
                        SliverPadding(
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                screenWidth * 0.03, // 3% of screen width
                          ),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                // For each pair of products, create a row with two cards
                                if (index.isEven) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      buildProductCard(
                                          context, products[index]),
                                      if (index + 1 < products.length)
                                        buildProductCard(
                                            context, products[index + 1]),
                                    ],
                                  );
                                } else {
                                  return SizedBox(
                                      height: screenHeight *
                                          0.02); // 2% of screen height
                                }
                              },
                              childCount: products.length,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
      ],
    );
  }

  Widget buildProductCard(BuildContext context, Map<String, dynamic> product) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      width: screenWidth * 0.45, // 45% of screen width
      height: screenHeight * 0.4, // 40% of screen height
      child: CardProduct(
        productName: product['name'] ?? 'Unknown',
        productPrice: "\$${product['price'] ?? '0.00'}",
        productImage: product['image'] ?? '',
        height: screenHeight * 0.25, // 25% of screen height
        productId: product['_id'] ?? '',
      ),
    );
  }
}
