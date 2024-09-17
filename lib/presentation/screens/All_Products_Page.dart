import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/widgets/Categorized_Scroll_Section.dart';
import 'package:flutter_application_1/presentation/widgets/Category_Appbar.dart';

class ProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the screen size
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;

    // Define your responsive sizes based on screen size
    double paddingBottom = screenHeight * 0.05; // 5% of screen height
    double verticalSpacing = screenHeight * 0.02; // 2% of screen height

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Product',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: paddingBottom),
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(
              height: verticalSpacing, // Example of vertical spacing
            ),
            Categorized_Scroll_Section(),
          ],
        ),
      ),
    );
  }
}
