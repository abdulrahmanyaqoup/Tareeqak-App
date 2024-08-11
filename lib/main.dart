import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(
    const ProviderScope(child: Tareeqak()),
  );
}

final ThemeData customTheme = ThemeData(
  primaryColor: const Color(0xFF1A405B),
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF1A405B),
    primary: const Color(0xFF1A405B),
    secondary: const Color(0xFF001E31),
    surface: Colors.white,
  ),
  scaffoldBackgroundColor: Colors.white,
  fontFamily: 'Helvetica Neue',
  buttonTheme: const ButtonThemeData(
    buttonColor: Color(0xFF1A405B),
    textTheme: ButtonTextTheme.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shadowColor: Colors.transparent,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
    ),
  ),
  navigationBarTheme: const NavigationBarThemeData(
    backgroundColor: Color(0xFF1A405B),
  ),
);

class Tareeqak extends StatelessWidget {
  const Tareeqak({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tareeqak',
      theme: customTheme,
      home: const BottomNavigation(),
    );
  }
}
