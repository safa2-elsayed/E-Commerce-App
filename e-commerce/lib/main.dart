import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubits/auth/auth_cubit.dart';
import 'screens/login.dart';
import 'screens/home.dart';
import 'screens/signUp.dart';
import 'screens/splash.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:e_commerce/cubits/auth/cart_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(),
        ),
        BlocProvider<CartCubit>(
        create: (_) => CartCubit()..loadCartFromFirestore(),
        )
      ],
      child: MaterialApp(
        title: 'LAZA E-Commerce',
        theme: ThemeData(
          primaryColor: const Color(0xFF9775FA),
          fontFamily: 'Inter',
          useMaterial3: true,
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          primaryColor: const Color(0xFF9775FA),
          fontFamily: 'Inter',
          useMaterial3: true,
          brightness: Brightness.dark,
        ),
        themeMode: ThemeMode.system,
        home: const SplashScreen(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/home': (context) => const HomeScreen(),
        },
        onGenerateRoute: (profile) {
          if (profile.name == '/profile') {
            return MaterialPageRoute(
              builder: (context) => const Scaffold(
                body: Center(child: Text("Profile Page")),
              ),
            );
          }
          return null;
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
