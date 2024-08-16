import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screens/profile/manualScreen.dart';
import 'app.dart';
import 'appThemes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(
    widgetsBinding: WidgetsFlutterBinding.ensureInitialized(),
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(
    const ProviderScope(child: Tareeqak()),
  );
}

class Tareeqak extends StatefulWidget {
  const Tareeqak({super.key});

  static GlobalKey<NavigatorState> navKey = GlobalKey();

  @override
  State<Tareeqak> createState() => _Tareeqak();
}

class _Tareeqak extends State<Tareeqak> {
  late Future<bool> isFirstTimeFuture;

  @override
  void initState() {
    super.initState();
    isFirstTimeFuture = _checkIfFirstTime();
  }

  Future<bool> _checkIfFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool('isFirstTime') ?? true;

    if (isFirstTime) {
      await prefs.setBool('isFirstTime', false);
    }

    return isFirstTime;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tareeqak',
      theme: appTheme,
      navigatorKey: Tareeqak.navKey,
      home: FutureBuilder<bool>(
        future: isFirstTimeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox.shrink();
          } else if (snapshot.hasError) {
            FlutterNativeSplash.remove();
            return const Center(child: Text('Error loading app'));
          } else {
            FlutterNativeSplash.remove();
            final showManualScreen = snapshot.data ?? true;
            return showManualScreen
                ? const ManualScreen(isProfile: false)
                : const App();
          }
        },
      ),
    );
  }
}
