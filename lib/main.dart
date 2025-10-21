import 'package:drips_water/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const DripsWater());
}

class DripsWater extends StatelessWidget {
  const DripsWater({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Drips Water",
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
