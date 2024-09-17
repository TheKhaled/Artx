import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/widgets/Card_Product.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductSectionCategory extends StatefulWidget {
  final String categoryName;

  const ProductSectionCategory({
    Key? key,
    required this.categoryName,
  }) : super(key: key);

  @override
  _ProductSectionCategoryState createState() => _ProductSectionCategoryState();
}

class _ProductSectionCategoryState extends State<ProductSectionCategory> {
  late Future<List<dynamic>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = fetchAllProducts();
  }

  Future<List<dynamic>> fetchAllProducts() async {
    try {
      final response = await http.get(
        Uri.parse('https://art-ecommerce-server.glitch.me/api/products'),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body) as List<dynamic>;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return FutureBuilder<List<dynamic>>(
      future: _productsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No products available'));
        } else {
          final filteredProducts = snapshot.data!
              .where(
                (product) => product['category'] == widget.categoryName,
              )
              .toList();

          if (filteredProducts.isEmpty) {
            return Center(child: Text('No products found in this category.'));
          }

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal:
                    screenWidth * 0.02, // Adjust padding based on screen width
                vertical: screenHeight *
                    0.01, // Adjust padding based on screen height
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Products in ${widget.categoryName}',
                    style: GoogleFonts.ebGaramond(
                      fontSize: screenWidth *
                          0.06, // Adjust font size based on screen width
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                      height: screenHeight *
                          0.02), // Adjust space based on screen height
                  ...List.generate((filteredProducts.length / 2).ceil(),
                      (index) {
                    int firstIndex = index * 2;
                    int secondIndex = firstIndex + 1;

                    return Padding(
                      padding: EdgeInsets.only(
                          bottom: screenHeight *
                              0.01), // Adjust padding based on screen height
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: CardProduct(
                              productName: filteredProducts[firstIndex]
                                      ['name'] ??
                                  'Unknown',
                              productPrice: filteredProducts[firstIndex]
                                          ['price']
                                      .toString() ??
                                  '0',
                              productImage:
                                  filteredProducts[firstIndex]['image'] ?? '',
                              height: screenHeight *
                                  0.3, // Adjust height based on screen height
                              productId: filteredProducts[firstIndex]['_id'],
                            ),
                          ),
                          SizedBox(
                              width: screenWidth *
                                  0.03), // Adjust space between cards based on screen width
                          if (secondIndex < filteredProducts.length)
                            Expanded(
                              child: CardProduct(
                                productName: filteredProducts[secondIndex]
                                        ['name'] ??
                                    'Unknown',
                                productPrice: filteredProducts[secondIndex]
                                            ['price']
                                        .toString() ??
                                    '0',
                                productImage: filteredProducts[secondIndex]
                                        ['image'] ??
                                    '',
                                height: screenHeight *
                                    0.3, // Adjust height based on screen height
                                productId: filteredProducts[secondIndex]['_id'],
                              ),
                            ),
                        ],
                      ),
                    );
                  }),
                  SizedBox(
                      height: screenHeight *
                          0.01), // Adjust space based on screen height
                  Divider(
                    color: Color.fromARGB(255, 201, 171, 129),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
