import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/widgets/Category_Appbar.dart';
import 'package:flutter_application_1/presentation/widgets/Product_Section_Category.dart';
import 'package:flutter_application_1/presentation/widgets/Search_Bar.dart';

class CategoryPage extends StatelessWidget {
  final String categoryId;
  final String categoryName;

  const CategoryPage({
    Key? key,
    required this.categoryId,
    required this.categoryName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    // Define responsive sizes
    double paddingBottom = screenHeight * 0.05; // 5% of screen height
    double searchBarHeight = screenHeight * 0.1; // 10% of screen height
    double productSectionHeight = screenHeight * 0.7; // 70% of screen height

    return Scaffold(
      appBar: CustomAppBar(
        title: categoryName,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: paddingBottom),
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              height: productSectionHeight,
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
              child: ProductSectionCategory(
                categoryName: categoryName,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
