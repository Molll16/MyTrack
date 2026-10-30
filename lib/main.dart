import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';

void main() {
  runApp(const AplikasiMyTrack());
}

class AplikasiMyTrack extends StatelessWidget {
  const AplikasiMyTrack({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const SplashScreen(),
    );
  }
}
