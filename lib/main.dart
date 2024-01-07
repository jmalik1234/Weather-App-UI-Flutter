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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ChangeNotifierProvider(
    create: (context) => AuthService(),
    child: const App(),
  ));
}

//will get called repeatedly
class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  void addToDb() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final person = {
      'Age': 5,
    };
    await _firestore.collection('tasks').doc('info').set(person);
  }

  @override
  Widget build(BuildContext context) {
    //try adding to search

    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      //called over and over again so after you login it'll
      //call AuthGate with updated info
      home: AuthGate(),
    );
  }
}
