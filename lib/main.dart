import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/firebase_options.dart';
import 'package:weather_app/screens/home.dart';
import 'package:weather_app/screens/reg.dart';
import 'package:weather_app/services/auth/auth_gate.dart';
import 'package:weather_app/services/auth/auth_services.dart';
import 'package:weather_app/services/login_or_reg.dart';
import 'package:weather_app/screens/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: const App(),
    ),
  );
}

//will get called repeatedly
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    //try adding to search

    return const MaterialApp(
      debugShowCheckedModeBanner: false,

      //called over and over again so after you login it'll
      //call AuthGate with updated info
      home: AuthGate(),
    );
  }
}
