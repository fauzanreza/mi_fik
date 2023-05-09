import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mi_fik/Components/Bars/bottom_bar.dart';
import 'package:mi_fik/Modules/APIs/DictionaryApi/Services/queries.dart';
import 'package:mi_fik/Pages/Landings/LoginPage/index.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool shouldUseFirestoreEmulator = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  if (shouldUseFirestoreEmulator) {
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  }
  final prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey("token_key")) {
    runApp(MyApp(signed: true));
  } else {
    runApp(MyApp(signed: false));
  }
}

class MyApp extends StatefulWidget {
  MyApp({Key key, this.signed}) : super(key: key);
  bool signed;

  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  DictionaryQueryService dctService;

  @override
  void initState() {
    dctService = DictionaryQueryService();
  }

  @override
  Widget build(BuildContext context) {
    //Lock device on portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Get dictionary collection
    dctService.getDictionaryType("QST-001");
    dctService.getDictionaryType("FBC-001");

    if (widget.signed) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Kumande Mobile',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const BottomBar(),
      );
    } else {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Kumande Mobile',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const LoginPage(),
      );
    }
  }
}
