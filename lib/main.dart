import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:self_tags/models/bubble.dart';
import 'package:self_tags/models/notes.dart';
import 'package:self_tags/models/user.dart';
import 'package:self_tags/screens/authentication_screen.dart';
import 'package:self_tags/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
  );
  final pref = await SharedPreferences.getInstance();
  bool? showBubbles = pref.getBool("bubbleStatus");
  List<String> usercache = pref.getStringList("userCache") ?? [];

  runApp(
    MultiProvider(
      providers: [
        (showBubbles != null) ? ChangeNotifierProvider(create: (context) => Bubble(status: showBubbles)) : ChangeNotifierProvider(create: (context) => Bubble.empty()),
        (usercache.isEmpty) ? ChangeNotifierProvider(create: (context) => User.empty()) : ChangeNotifierProvider(create: (context) => User.fromList(usercache)),
        ChangeNotifierProvider(create: (context) => Notes.empty())
      ],
      child: OverlaySupport.global(child: MyApp(usercache: usercache))
    )
  );
}

class MyApp extends StatelessWidget {
  final List<String> usercache;

  const MyApp({super.key, required this.usercache});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Self tags',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      useMaterial3: true,
      ),
      home: (usercache.isEmpty) ? const AuthenticationScreen() : const HomeScreen(),
    );
  }
}

