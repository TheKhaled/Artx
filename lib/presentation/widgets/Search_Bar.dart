import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/model/product_model.dart';
import 'package:flutter_application_1/presentation/screens/Details_Screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class SearchBarSection extends StatefulWidget {
  final Function(String, bool) onSearch;

  SearchBarSection({required this.onSearch});

  @override
  _SearchBarSectionState createState() => _SearchBarSectionState();
}

class _SearchBarSectionState extends State<SearchBarSection> {
  List<ProductModel> _products = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.get(
          Uri.parse('https://art-ecommerce-server.glitch.me/api/products'));

      if (response.statusCode == 200) {
        List<dynamic> productList = json.decode(response.body);
        setState(() {
          _products =
              productList.map((json) => ProductModel.fromJson(json)).toList();
        });
      }
    } catch (e) {
      print('Error fetching products: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Define responsive text styles
    TextStyle headerStyle = GoogleFonts.ebGaramond(
      fontSize: screenWidth * 0.06, // 6% of screen width
      fontWeight: FontWeight.bold,
    );

    TextStyle hintStyle = GoogleFonts.openSans(
      fontSize: screenWidth * 0.04, // 4% of screen width
      color: Colors.grey[600],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What are you looking for?',
          style: headerStyle,
        ),
        SizedBox(
            height: screenWidth * 0.04), // Adjust height based on screen width
        TextField(
          onChanged: (query) {
            widget.onSearch(query, query.isNotEmpty);
          },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
                vertical:
                    screenWidth * 0.04), // Adjust padding based on screen width
            hintText: 'Search...',
            hintStyle: hintStyle,
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(screenWidth *
                  0.07), // Adjust border radius based on screen width
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(screenWidth * 0.07),
              borderSide: BorderSide(
                color: Color.fromARGB(255, 201, 171, 129),
                width: 2.0,
              ),
            ),
            prefixIcon: Icon(
              Icons.search,
              color: Color.fromARGB(255, 201, 171, 129),
              size:
                  screenWidth * 0.06, // Adjust icon size based on screen width
            ),
          ),
        ),
      ],
    );
  }
}

class SearchOverlaySection extends StatelessWidget {
  final String searchQuery;
  final Function onClose;

  SearchOverlaySection({required this.searchQuery, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return FutureBuilder(
      future: http.get(
          Uri.parse('https://art-ecommerce-server.glitch.me/api/products')),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error fetching products'));
        }

        List<dynamic> products = json.decode(snapshot.data!.body);

        List<ProductModel> filteredProducts = products
            .map((json) => ProductModel.fromJson(json))
            .where((product) => product.productName
                .toLowerCase()
                .contains(searchQuery.toLowerCase()))
            .toList();

        return Align(
          alignment: Alignment.center,
          child: Material(
            elevation: 8,
            color: Colors.white,
            borderRadius: BorderRadius.circular(screenWidth *
                0.04), // Adjust border radius based on screen width
            child: Padding(
              padding: EdgeInsets.all(
                  screenWidth * 0.04), // Adjust padding based on screen width
              child: Container(
                width: screenWidth * 0.9, // Adjust width for responsiveness
                constraints: BoxConstraints(
                  maxHeight:
                      screenHeight * 0.6, // Limit height for responsiveness
                ),
                child: filteredProducts.isNotEmpty
                    ? ListView.builder(
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          return ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailsScreen(
                                    product: product,
                                  ),
                                ),
                              );
                              onClose(); // Close the overlay on tap
                            },
                            leading: Image.network(
                              product.imagePath,
                              width: screenWidth *
                                  0.15, // Adjust width based on screen width
                              height: screenWidth *
                                  0.15, // Adjust height based on screen width
                              fit: BoxFit.cover,
                            ),
                            title: Text(
                              product.productName,
                              style: GoogleFonts.openSans(
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth *
                                    0.04, // Adjust font size based on screen width
                              ),
                            ),
                            subtitle: Text(
                              "\$${product.productPrice}",
                              style: GoogleFonts.openSans(
                                fontSize: screenWidth *
                                    0.035, // Adjust font size based on screen width
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          'No products found',
                          style: GoogleFonts.openSans(
                            fontSize: screenWidth *
                                0.04, // Adjust font size based on screen width
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
