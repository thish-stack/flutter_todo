import 'package:flutter/material.dart';
import 'package:producthive/pages/home_page.dart';
// import 'package:producthive/splash_screen.dart';

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

       
        dialogTheme: DialogTheme(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20), 
          ),
          backgroundColor: Colors.white, 
          titleTextStyle: const TextStyle(
            color: Color.fromARGB(255, 226, 72, 141), 
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          contentTextStyle: const TextStyle(
            color: Colors.black87, 
            fontSize: 16,
          ),
        ),

       
        colorScheme: const ColorScheme.light(
          primary:
              Color.fromARGB(255, 226, 72, 141), 
          onPrimary: Colors.white,
          onSurface: Colors.black, 
        ),
      ),
    );
  }
}
