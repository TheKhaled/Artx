import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/screens/CartScreen.dart';
import 'package:flutter_application_1/provider/cart_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

AppBar MainAppbar(String title, BuildContext context) {
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: Color.fromARGB(255, 201, 171, 129),
    shape: Border(
      bottom: BorderSide(width: 2, color: Color.fromARGB(255, 156, 126, 84)),
    ),
    toolbarHeight: 80,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Image.asset(
            'assets/Logo.png',
            fit: BoxFit.cover,
            height: 50,
          ),
        ),
        Text(
          title,
          style: GoogleFonts.ebGaramond(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Consumer<CartProvider>(
          builder: (context, cartProvider, child) {
            final totalItems = cartProvider.totalItemsInCart;

            return IconButton(
              color: Colors.black,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartScreen()),
                );
              },
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 32,
                  ),
                  if (totalItems > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: BoxConstraints(
                          minWidth: 24,
                          minHeight: 24,
                        ),
                        child: Center(
                          child: Text(
                            '$totalItems',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    ),
  );
}
