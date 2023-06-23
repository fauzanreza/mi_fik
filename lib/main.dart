import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Bars/bottom_bar.dart';
import 'package:mi_fik/Modules/APIs/DictionaryApi/Services/queries.dart';
import 'package:mi_fik/Modules/APIs/UserApi/Services/commands.dart';
import 'package:mi_fik/Modules/Translators/dictionary.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/Landings/LoginPage/index.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mi_fik/Pages/Landings/RegisterPage/index.dart';
import 'package:mi_fik/firebase_options.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> fireFCMHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(fireFCMHandler);
  await FlutterLocalNotificationsPlugin()
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  //FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  if (shouldUseFirestoreEmulator) {
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  }

  final prefs = await SharedPreferences.getInstance();
  String langKey = "en";
  if (prefs.containsKey("lang_key")) {
    langKey = prefs.getString("lang_key");
  }

  if (prefs.containsKey("token_key")) {
    if (prefs.containsKey("role_general_key")) {
      isFinishedRegis = true;
    } else {
      isFinishedRegis = false;
    }

    runApp(MyApp(signed: true, finishRegis: isFinishedRegis, lang: langKey));
  } else {
    runApp(MyApp(signed: false, finishRegis: isFinishedRegis, lang: langKey));
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key key, this.signed, this.finishRegis, this.lang})
      : super(key: key);
  final bool signed;
  final bool finishRegis;
  final String lang;

  @override
  StateMyApp createState() => StateMyApp();
}

class StateMyApp extends State<MyApp> {
  DictionaryQueryService dctService;
  UserCommandsService userService;

  @override
  void initState() {
    super.initState();
    dctService = DictionaryQueryService();
    userService = UserCommandsService();
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    FlutterLocalNotificationsPlugin().initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        FlutterLocalNotificationsPlugin().show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                color: primaryColor,
                enableLights: true,
                icon: "@mipmap/ic_launcher",
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      double fullHeight = MediaQuery.of(context).size.height;
      double fullWidth = MediaQuery.of(context).size.width;

      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog<String>(
            context: context,
            barrierColor: primaryColor.withOpacity(0.5),
            builder: (BuildContext context) {
              return StatefulBuilder(builder: (context, setState) {
                return AlertDialog(
                    insetPadding: EdgeInsets.all(paddingXSM),
                    contentPadding: EdgeInsets.all(paddingXSM),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(roundedLG)),
                    content: SizedBox(
                        height: fullHeight * 0.75,
                        width: fullWidth,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  icon: const Icon(Icons.close),
                                  tooltip: 'Back',
                                  onPressed: () {
                                    Get.back();
                                  },
                                ),
                              ),
                              Expanded(
                                  child: ListView(
                                padding: EdgeInsets.symmetric(
                                    horizontal: paddingXSM),
                                children: [
                                  Text(notification.title,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500)),
                                  SizedBox(
                                    height: paddingLg,
                                  ),
                                  Text(notification.body),
                                  SizedBox(
                                    height: paddingLg,
                                  ),
                                ],
                              )),
                            ])));
              });
            });
      }
    });

    // Get dictionary collection

    getToken();
  }

  getToken() async {
    await dctService.getDictionaryType("QST-001");
    await dctService.getDictionaryType("FBC-001");
    await dctService.getDictionaryType("ATT-001");
    await dctService.getDictionaryType("SLC-001");
    token = await FirebaseMessaging.instance.getToken();
    //print(token);
  }

  @override
  Widget build(BuildContext context) {
    //Lock device on portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    String langCode = "en";
    slctLang = LangList.en;
    String countryCode = "US";

    if (widget.lang == "id") {
      langCode = "id";
      countryCode = "ID";
      slctLang = LangList.id;
    }

    if (widget.signed) {
      return FutureBuilder<String>(
        future: FirebaseMessaging.instance.getToken(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            String tokens = snapshot.data;
            userService.putFirebase(tokens);

            if (widget.finishRegis) {
              return GetMaterialApp(
                translations: Dictionaries(),
                locale: Locale(langCode, countryCode),
                fallbackLocale: Locale(langCode, countryCode),
                debugShowCheckedModeBanner: false,
                title: 'Mi-FIK',
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                ),
                home: const BottomBar(),
              );
            } else {
              return GetMaterialApp(
                translations: Dictionaries(),
                locale: Locale(langCode, countryCode),
                fallbackLocale: Locale(langCode, countryCode),
                debugShowCheckedModeBanner: false,
                title: 'Mi-FIK',
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                ),
                home: const RegisterPage(isLogged: true),
              );
            }
          } else {
            return const CircularProgressIndicator();
          }
        },
      );
    } else {
      return GetMaterialApp(
        translations: Dictionaries(),
        locale: const Locale("en", "US"),
        fallbackLocale: const Locale("en", "US"),
        debugShowCheckedModeBanner: false,
        title: 'Mi-FIK',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const LoginPage(),
      );
    }
  }
}
