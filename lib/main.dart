import 'package:flutter/material.dart';
import 'package:producthive/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 226, 72, 141),
        scaffoldBackgroundColor: Colors.white,

        // Customize the dialog theme
        dialogTheme: DialogTheme(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20), // Rounded corners for the dialog
          ),
          backgroundColor: Colors.white, // Background color for dialogs
          titleTextStyle: const TextStyle(
            color: Color.fromARGB(255, 226, 72, 141), // Title text color
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          contentTextStyle: const TextStyle(
            color: Colors.black87, // Content text color
            fontSize: 16,
          ),
        ),

        // Set up color scheme for buttons in dialogs
        colorScheme: const ColorScheme.light(
          primary:
              Color.fromARGB(255, 226, 72, 141), // Primary color for buttons
          onPrimary: Colors.white, // Text color for buttons
          onSurface: Colors.black, // Text color for other elements
        ),
      ),
    );
  }
}
