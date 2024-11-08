// splash_screen.dart
// import 'package:flutter/material.dart';
// import 'package:producthive/pages/home_page.dart'; // Adjust the import according to your structure

// class SplashScreen extends StatelessWidget {
//   const SplashScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // Simulating a loading process
//     Future.delayed(const Duration(seconds: 5), () {
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (context) => const HomePage()),
//       );
//     });

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset('assets/logo.jpg', width: 150, height: 150), // Your logo here
//             const SizedBox(height: 20),
//             const Text(
//               'ProductHive',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:producthive/pages/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _playSplashSound();
    _navigateToHome();
  }

  // Function to play sound
  Future<void> _playSplashSound() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/splash_sound.mp3'));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  // Navigate to HomePage after 3 seconds
  void _navigateToHome() {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color.fromARGB(255, 226, 72, 141), // Match your theme color
      body: Center(
        child: Image.asset(
          'assets/icon/todoapp.jpg', // Make sure to add your logo image here
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}
