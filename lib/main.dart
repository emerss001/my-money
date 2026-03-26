import 'package:flutter/material.dart';
import 'package:my_money/pages/home.dart';
import 'package:my_money/pages/login.dart';
import 'package:my_money/pages/register.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Configuração de rotas do app
      initialRoute: "/",
      routes: {
        "/": (context) => const HomePage(),
        "/login": (context) => const LoginPage(),
        "/register": (context) => const RegisterPage(),
      },
      debugShowCheckedModeBanner: false,
      title: 'My Money',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(
          0xFF121214,
        ), // Fundo escuro principal
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00875F), // Verde principal
          secondary: Color(0xFF00B37E), // Verde claro
          surface: Color(0xFF202024), // Fundo dos cards
        ),
      ),
    );
  }
}
