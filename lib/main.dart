import 'package:flutter/material.dart';
import 'core/di/dependency_injection.dart';
import 'presentation/pages/welcome_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupInjector();
  runApp(const SafaricomApp());
}

class SafaricomApp extends StatelessWidget {
  const SafaricomApp({super.key});

  @override
  Widget build(BuildContext context) {
    const red = Color(0xFFE21B2D);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'M-PESA',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: red, primary: red),
        fontFamily: 'Arial',
      ),
      home: const WelcomePage(),
    );
  }
}
