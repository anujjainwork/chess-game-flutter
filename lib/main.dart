import 'package:chess/features/homepage/presentation/view/homepage.dart';
import 'package:chess/routes/routes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
       onGenerateRoute: AppRouter.onGenerateRoute,
      home: HomePage(), 
    );
  }
}
