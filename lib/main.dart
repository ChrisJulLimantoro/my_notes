import 'package:flutter/material.dart';
import 'package:my_notes/screens/lock.dart';
import 'package:my_notes/screens/home.dart';
import 'package:my_notes/screens/detail.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:my_notes/models/note.dart';

void main() async {
  // Ensure Flutter bindings are initialized before using Hive
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive with the correct directory
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  // Initialize Hive and open boxes
  await Hive.initFlutter();
  // await BoxCollection.open('my_notes', {'settings', 'notes'});

  // Register the Note adapter
  Hive.registerAdapter(NoteAdapter()); // Use generated adapter name
  await Hive.openBox('settings');
  await Hive.openBox('notes');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'My Notes',
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
