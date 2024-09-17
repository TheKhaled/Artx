import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/widgets/Card_Product.dart';
import 'package:flutter_application_1/presentation/widgets/Search_Bar.dart';
import 'package:http/http.dart' as http;

class Categorized_Scroll_Section extends StatefulWidget {
  const Categorized_Scroll_Section({
    super.key,
  });

  @override
  State<Categorized_Scroll_Section> createState() =>
      _Categorized_Scroll_SectionState();
}

class _Categorized_Scroll_SectionState
    extends State<Categorized_Scroll_Section> {
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
    // Get the screen size
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SearchBarSection(
        //   onSearch: (String, bool) {},
        // ),
        isLoading
            ? Center(child: CircularProgressIndicator())
            : errorMessage != null
                ? Center(child: Text(errorMessage!))
                : SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: CustomScrollView(
                      slivers: [
                        SliverPadding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.03),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                // Calculate width based on screen size
                                final cardWidth = screenWidth * 0.45;

                                // For each pair of products, create a row with two cards
                                if (index.isEven) {
                                  return Row(
                                    children: [
                                      buildProductCard(
                                          context, products[index], cardWidth),
                                      SizedBox(width: screenWidth * 0.03),
                                      if (index + 1 < products.length)
                                        buildProductCard(context,
                                            products[index + 1], cardWidth),
                                    ],
                                  );
                                } else {
                                  return SizedBox(height: screenWidth * 0.03);
                                }
                              },
                              childCount: (products.length / 2).ceil(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
      ],
    );
  }
}

Widget buildProductCard(
    BuildContext context, Map<String, dynamic> product, double cardWidth) {
  return SizedBox(
    width: cardWidth,
    height: cardWidth * 1.3, // Maintain aspect ratio
    child: CardProduct(
      productName: product['name'] ?? 'Unknown',
      productPrice: "\$${product['price'] ?? '0.00'}",
      productImage: product['image'] ?? '',
      height: cardWidth * 0.7,
      productId: product['_id'] ?? '',
    ),
  );
}
