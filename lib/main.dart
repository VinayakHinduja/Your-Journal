import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle());
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .whenComplete(() => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Your Journal',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 4, 27, 46),
          brightness: Brightness.dark,
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          dragHandleColor: Colors.white,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
