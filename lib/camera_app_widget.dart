import 'package:flutter/material.dart';

import 'home_screen.dart';

class CameraMarcaDaguaAppWidget extends StatelessWidget {
  const CameraMarcaDaguaAppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: Colors.purple,
      ),
      home: const HomeScreen(),
    );
  }
}
