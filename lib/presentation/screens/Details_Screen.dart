import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/model/product_model.dart';
import 'package:flutter_application_1/presentation/widgets/Category_Appbar.dart';
import 'package:flutter_application_1/presentation/widgets/Main_Button.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailsScreen extends StatelessWidget {
  final ProductModel product;

  DetailsScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double padding = screenSize.width * 0.05;

    return Scaffold(
      appBar: CustomAppBar(title: 'Product Details'),
      body: Column(
        children: [
          ClipPath(
            clipper: BottomHalfCircleClipper(),
            child: product.imagePath.isNotEmpty
                ? Image.network(
                    product.imagePath,
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Center(child: Icon(Icons.error, size: 50));
                    },
                  )
                : Container(
                    width: double.infinity,
                    height: 300,
                    color: Colors.grey[200],
                    child: Center(child: Icon(Icons.image, size: 50)),
                  ),
          ),
          Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.productName,
                  style: GoogleFonts.ebGaramond(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  '${product.productPrice.toString()} \$',
                  style: GoogleFonts.ebGaramond(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Divider(
                  color: Color.fromARGB(255, 201, 171, 129),
                ),
                SizedBox(height: 20),
                Text(
                  'Description',
                  style: GoogleFonts.ebGaramond(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  product.productDetails,
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Color.fromARGB(255, 201, 171, 129),
          ),
          SizedBox(height: 30),
          Main_Button(
            buttontext: 'Add to cart',
            color: Colors.black,
            onPressed: () {
              // Add to cart functionality here
            },
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}

class BottomHalfCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
      size.width / 2,
      size.height + 50,
      size.width,
      size.height - 50,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
