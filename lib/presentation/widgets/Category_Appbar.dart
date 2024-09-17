import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData icon;
  final Color appBarColor;
  final Color borderColor;
  final double toolbarHeight;
  final double iconSize;
  final TextStyle titleStyle;
  final EdgeInsetsGeometry logoPadding;
  final List<Widget>? actions;

  CustomAppBar({
    required this.title,
    this.icon = Icons.shopping_bag_outlined,
    this.appBarColor = const Color.fromARGB(255, 201, 171, 129),
    this.borderColor = const Color.fromARGB(255, 156, 126, 84),
    this.toolbarHeight = 80.0,
    this.iconSize = 30.0,
    this.titleStyle = const TextStyle(
      color: Colors.black,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    this.logoPadding = const EdgeInsets.only(right: 16.0),
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    // Get the screen width and height
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Adjust sizes based on screen width
    final double adjustedToolbarHeight =
        screenHeight * 0.1; // 10% of screen height
    final double adjustedIconSize = screenWidth * 0.08; // 8% of screen width
    final double adjustedFontSize = screenWidth * 0.05; // 5% of screen width

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: appBarColor,
      shape: Border(
        bottom: BorderSide(width: 2, color: borderColor),
      ),
      toolbarHeight: adjustedToolbarHeight,
      title: Row(
        children: [
          // Back button
          IconButton(
            icon:
                Icon(Icons.arrow_back_ios_new_outlined, size: adjustedIconSize),
            onPressed: () {
              Navigator.pop(
                  context); // Use pop instead of pushReplacement for typical back navigation
            },
          ),
          // Expanded to keep title in the center and actions at the end
          Expanded(
            child: Center(
              child: Text(
                title,
                style: GoogleFonts.ebGaramond(
                  color: Colors.black,
                  fontSize: adjustedFontSize,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          // Optional actions (aligned to the right)
          if (actions != null) ...actions!,
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight);
}
