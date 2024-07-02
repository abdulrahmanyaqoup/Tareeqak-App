import 'package:flutter/material.dart';
import 'package:finalproject/Screens/tabs.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const ProviderScope( child: Tareeqak()));
}

final seedColor = Color(0xFF4A4B7B);

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.light,
    seedColor: seedColor,
    primary: Color(0xFF4A4B7B), 
    secondary: Color(0xFF3C3846), 
    tertiary: Color(0xFFFDE9CC), 
  ),
  textTheme: GoogleFonts.latoTextTheme(
    ThemeData(brightness: Brightness.light).textTheme,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF4A4B7B), 
    iconTheme: IconThemeData(color: Colors.white), 
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF4A4B7B), 
    foregroundColor: Colors.white, 
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Color(0xFF4A4B7B), 
  ),
  iconTheme: IconThemeData(
    color: Color(0xFF4A4B7B), 
  ),
  primaryIconTheme: IconThemeData(
    color: Colors.white, 
  ),
);


class Tareeqak extends StatelessWidget {
  const Tareeqak({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Maseer',
      theme: theme,
      home: Tabs(),
    );
  }
}

