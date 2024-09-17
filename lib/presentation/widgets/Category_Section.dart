import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/screens/category_page.dart';
import 'package:flutter_application_1/presentation/widgets/Color.dart';
import 'package:http/http.dart' as http;

class CategoriesSection extends StatefulWidget {
  @override
  _CategoriesSectionState createState() => _CategoriesSectionState();
}

class _CategoriesSectionState extends State<CategoriesSection> {
  List<Category> _categories = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    final url = 'https://art-ecommerce-server.glitch.me/api/categories';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _categories = data.map((item) => Category.fromJson(item)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load categories';
          _isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'An error occurred: $error';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: theWebColor,
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!));
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _categories.map((category) {
            return CategoryButton(
              iconPath:
                  category.categoryImage ?? 'https://via.placeholder.com/80',
              label: category.categoryName,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryPage(
                      categoryId: category.id,
                      categoryName: category.categoryName,
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final String iconPath;
  final String label;
  final VoidCallback onPressed;

  const CategoryButton({
    required this.iconPath,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: screenWidth * 0.02, vertical: 8.0),
      child: Column(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Color.fromARGB(255, 201, 171, 129),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: BorderSide(
                  color: Color.fromARGB(255, 201, 171, 129),
                  width: 2.0,
                ),
              ),
              padding: EdgeInsets.zero,
            ),
            onPressed: onPressed,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(
                iconPath,
                width: screenWidth * 0.2, // Adjust width based on screen width
                height:
                    screenWidth * 0.2, // Adjust height based on screen width
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            label,
            style: TextStyle(
              fontSize:
                  screenWidth * 0.04, // Adjust font size based on screen width
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class Category {
  final String id;
  final String categoryName;
  final String categoryImage;

  Category({
    required this.id,
    required this.categoryName,
    required this.categoryImage,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'],
      categoryName: json['categoryName'],
      categoryImage: json['categoryImage'],
    );
  }
}
