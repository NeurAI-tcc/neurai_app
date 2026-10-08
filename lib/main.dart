import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neurai_app/views/login_page.dart';


void main() {
  runApp(DevicePreview(enabled: true, builder: (context) => const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NeurAI Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.alanSansTextTheme(),
        scaffoldBackgroundColor: const Color(0xFFF0F8FF), // Fundo azul claro
        fontFamily: 'Alan Sans', // Substitua pela fonte desejada
      ),
      home: const LoginPage(),
    );
  }
}