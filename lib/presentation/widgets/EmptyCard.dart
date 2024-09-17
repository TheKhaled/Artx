import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/screens/All_Products_Page.dart';
import 'package:flutter_application_1/presentation/widgets/Color.dart';
import 'package:flutter_application_1/presentation/widgets/Main_Button.dart';
import 'package:google_fonts/google_fonts.dart';

class Emptycard extends StatelessWidget {
  const Emptycard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: Colors.grey,
          ),
          SizedBox(height: 20),
          Text(
            "Your cart is empty",
            style: GoogleFonts.openSans(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Looks like you haven't added anything to your cart yet.",
              style: GoogleFonts.openSans(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 20),
          Main_Button(
            buttontext: 'Shop Now',
            color: theWebColor,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
