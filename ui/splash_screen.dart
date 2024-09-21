import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'photos_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PhotosScreen()),
      );
    });
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          'Osama Demo',
          style: GoogleFonts.sofadiOne(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}
