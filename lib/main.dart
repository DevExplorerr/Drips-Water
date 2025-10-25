import 'package:drips_water/core/theme/app_theme.dart';
import 'package:drips_water/firebase/firebase_options.dart';
import 'package:drips_water/presentation/screens/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const DripsWater());
}

class DripsWater extends StatelessWidget {
  const DripsWater({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Drips Water",
      theme: AppTheme.appTheme,
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
