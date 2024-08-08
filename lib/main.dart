import 'package:finalproject/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Provider/universityProvider.dart';
import 'Provider/userProvider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(
    const ProviderScope(child: Tareeqak()),
  );
}

const seedColor = Color(0xFF4A4B7B);

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: seedColor,
    primary: const Color(0xFF4A4B7B),
    secondary: const Color(0xFF3C3846),
    tertiary: const Color(0xFFFDE9CC),
  ),
  textTheme: GoogleFonts.latoTextTheme(
    ThemeData(brightness: Brightness.light).textTheme,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF4A4B7B),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF4A4B7B),
    foregroundColor: Colors.white,
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Color(0xFF4A4B7B),
  ),
  iconTheme: const IconThemeData(
    color: Color(0xFF4A4B7B),
  ),
  primaryIconTheme: const IconThemeData(
    color: Colors.white,
  ),
);

class Tareeqak extends ConsumerStatefulWidget {
  const Tareeqak({super.key});

  @override
  TareeqakState createState() => TareeqakState();
}

class TareeqakState extends ConsumerState {
  @override
  initState() {
    super.initState();
    ref.read(universityProvider.notifier).getUniversities();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tareeqak',
      theme: theme,
      home: const BottomNavigation(),
    );
  }
}
