import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/widgets/Category_Section.dart';
import 'package:flutter_application_1/presentation/widgets/Color.dart';
import 'package:flutter_application_1/presentation/widgets/Main_Appbar.dart';
import 'package:flutter_application_1/presentation/widgets/Product_list_Section.dart';
import 'package:flutter_application_1/presentation/widgets/Search_Bar.dart';
import 'package:flutter_application_1/presentation/widgets/image_slider.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isSearchActive = false; // To control the overlay visibility
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppbar('Home', context),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 50),
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                // Search bar that can trigger the overlay
                SearchBarSection(
                  onSearch: (query, isOverlayVisible) {
                    setState(() {
                      searchQuery = query;
                      isSearchActive =
                          isOverlayVisible; // Show overlay when needed
                    });
                  },
                ),
                Divider(
                  color: theWebColor,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      Text(
                        'Events',
                        style: GoogleFonts.ebGaramond(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: theWebColor,
                ),
                ComplicatedImageDemo(),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  color: theWebColor,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      Text(
                        'Categories',
                        style: GoogleFonts.ebGaramond(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: theWebColor,
                ),
                CategoriesSection(),
                ProductSection(),
              ],
            ),
          ),

          // Search overlay that shows over everything
          if (isSearchActive)
            GestureDetector(
              onTap: () {
                setState(() {
                  isSearchActive = false; // Close overlay on tap outside
                });
              },
              child: Positioned.fill(
                child: Material(
                  color: Colors.black.withOpacity(0.5),
                  child: SearchOverlaySection(
                    searchQuery: searchQuery,
                    onClose: () {
                      setState(() {
                        isSearchActive = false;
                      });
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
