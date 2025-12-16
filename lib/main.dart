import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/core/theme/app_theme.dart';
import 'package:drips_water/data/repositories/cart_repository.dart';
import 'package:drips_water/data/services/cart_service.dart';
import 'package:drips_water/firebase/firebase_options.dart';
import 'package:drips_water/logic/providers/cart_provider.dart';
import 'package:drips_water/logic/providers/favorite_provider.dart';
import 'package:drips_water/data/repositories/favorite_repository.dart';
import 'package:drips_water/data/services/auth_service.dart';
import 'package:drips_water/data/services/favorite_service.dart';
import 'package:drips_water/presentation/screens/home/home_screen.dart';
import 'package:drips_water/presentation/screens/splash/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  runApp(const DripsWater());
}

class DripsWater extends StatelessWidget {
  const DripsWater({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: authService.value.authStateChanges,
      builder: (context, snapshot) {
        final user = snapshot.data;
        return MultiProvider(
          providers: [
            // Favorite Provider
            ChangeNotifierProvider(
              create: (_) =>
                  FavoriteProvider(FavoriteService(FavoriteRepository())),
            ),

            // Cart Provider
            if (user != null) ...[
              Provider<CartRepository>(create: (_) => CartRepository()),
              Provider<CartService>(
                create: (ctx) => CartService(ctx.read<CartRepository>()),
              ),
              ChangeNotifierProvider<CartProvider>(
                key: ValueKey(user.uid),
                create: (ctx) {
                  return CartProvider(
                    repo: ctx.read<CartRepository>(),
                    uid: user.uid,
                    service: ctx.read<CartService>(),
                  );
                },
              ),
            ],
          ],
          child: MaterialApp(
            title: "Drips Water",
            theme: AppTheme.appTheme,
            debugShowCheckedModeBanner: false,
            home: StreamBuilder<User?>(
              stream: authService.value.authStateChanges,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Scaffold(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    body: Center(
                      child: LoadingAnimationWidget.waveDots(
                        color: AppColors.primary,
                        size: 45,
                      ),
                    ),
                  );
                } else if (snapshot.hasData) {
                  return const HomeScreen();
                } else {
                  return const SplashScreen();
                }
              },
            ),
          ),
        );
      },
    );
  }
}
