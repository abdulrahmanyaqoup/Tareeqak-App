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
  ),
  scaffoldBackgroundColor: Colors.white,
  fontFamily: 'Helvetica Neue',
  buttonTheme: const ButtonThemeData(
    buttonColor: Color(0xFF1A405B),
    textTheme: ButtonTextTheme.primary,
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
