import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'providers/app_state.dart' as local;
import 'screens/home_screen.dart';
import 'screens/gpa_calculator_screen.dart';
import 'screens/wes_evaluation_screen.dart';
import 'screens/upgrade_premium_screen.dart';
import 'services/ad_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // ✅ Configure test ads for emulator to prevent crash
    final config = RequestConfiguration(testDeviceIds: ['EMULATOR']);
    MobileAds.instance.updateRequestConfiguration(config);

    // ✅ Initialize Google Mobile Ads
    await MobileAds.instance.initialize();
    await AdService.initialize();
  } catch (e) {
    debugPrint('Ad initialization failed: $e');
  }

  // ✅ Load premium status
  final prefs = await SharedPreferences.getInstance();
  final isPremium = prefs.getBool('isPremium') ?? false;

  runApp(
    ChangeNotifierProvider(
      create: (_) => local.AppState()..setPremium(isPremium),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPA & WES Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      routes: {
        '/gpa': (context) => const GpaCalculatorScreen(),
        '/wes': (context) => const WesEvaluationScreen(),
        '/premium': (context) => const PremiumScreen(),
      },
    );
  }
}
