import 'package:flutter/material.dart';
import 'package:my_notes/screens/lock.dart';
import 'package:my_notes/screens/home.dart';
import 'package:my_notes/screens/detail.dart';

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
          '/new': (context) => const DetailScreen(isNew: true),
          '/detail': (context) => const DetailScreen(isNew: false),
        });
  }
}
