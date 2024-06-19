import 'package:flutter/material.dart';
import 'package:my_notes/screens/lock.dart';
import 'package:my_notes/screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: const LockScreen(),
        routes: {
          '/home': (context) => const HomeScreen(),
          '/lock': (context) => const LockScreen(),
        });
  }
}
