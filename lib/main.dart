import 'dart:convert';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Backgrounds/loading.dart';
import 'package:mi_fik/Components/Bars/bottom_bar.dart';
import 'package:mi_fik/Components/Dialogs/bg_fcm_dialog.dart';
import 'package:mi_fik/Components/Dialogs/reminder_dialog.dart';
import 'package:mi_fik/Modules/APIs/DictionaryApi/Services/queries.dart';
import 'package:mi_fik/Modules/APIs/UserApi/Services/commands.dart';
import 'package:mi_fik/Modules/Routes/collection.dart';
import 'package:mi_fik/Modules/Routes/page_routes.dart';
import 'package:mi_fik/Modules/Translators/dictionary.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/Landings/LoginPage/index.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mi_fik/Pages/Landings/RegisterPage/index.dart';
import 'package:mi_fik/Pages/SubMenus/DetailPage/index.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

@pragma('vm:entry-point')
//not finished
Future<void> fireFCMHandler(RemoteMessage message) async {
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // final AndroidFlutterLocalNotificationsPlugin plugin =
  //     FlutterLocalNotificationsPlugin().resolvePlatformSpecificImplementation<
  //         AndroidFlutterLocalNotificationsPlugin>();

  // if (plugin != null) {
  //   await plugin.createNotificationChannel(channel);
  // }

  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  //}
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  FlutterNativeSplash.remove();

  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();

  //FirebaseMessaging.onBackgroundMessage(fireFCMHandler);
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

  // if (shouldUseFirestoreEmulator) {
  //   FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  // }

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

    FirebaseMessaging.onBackgroundMessage(fireFCMHandler);
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      FlutterLocalNotificationsPlugin().show(notification.hashCode,
          notification.title, notification.body, fcmConfig);

      if (notification != null && android != null) {
        if (message.data["module"] == "event") {
          Get.to(() => DetailPage(passSlug: message.data["slug"]));
        } else if (message.data["module"] == "reminder") {
          if (message.data["type"] == "event") {
            Get.to(() => DetailPage(passSlug: message.data["slug"]));
          } else if (message.data["type"] == "task") {
            selectedIndex = 1;
            Get.toNamed(CollectionRoute.bar);
          }
          Get.dialog(
            ReminderDialog(
              slug: message.data["slug"],
              title: message.data["content_title"],
              dateStart: message.data["content_date_start"],
              isDirect: false,
              from: message.data["type"],
              content: jsonDecode(message.data["content"]),
            ),
          );
        } else if (message.data["module"] == "faq") {
          Get.toNamed(CollectionRoute.myfaq);
        } else if (message.data["module"] == "announcement") {
          Get.dialog(
            BgFcmDialog(
                title: message.notification.title,
                body: message.notification.body,
                date: message.sentTime),
          );
        } else if (message.data["module"] == "request") {
          Get.toNamed(CollectionRoute.role);
        } else if (message.data["module"] == "user") {
          Get.toNamed(CollectionRoute.profile);
        } else if (message.data["module"] == "home") {
          Get.toNamed(CollectionRoute.bar);
        }
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      FlutterLocalNotificationsPlugin().show(notification.hashCode,
          notification.title, notification.body, fcmConfig);

      if (notification != null && android != null) {
        if (message.data["module"] == "reminder") {
          Get.dialog(
            ReminderDialog(
              slug: message.data["slug"],
              title: message.data["content_title"],
              dateStart: message.data["content_date_start"],
              isDirect: false,
              from: message.data["type"],
              content: jsonDecode(message.data["content"]),
            ),
          );
        } else if (message.data["module"] == "announcement") {
          Get.dialog(
            BgFcmDialog(
                title: message.notification.title,
                body: message.notification.body,
                date: message.sentTime),
          );
        }
      }
    });

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

    getToken();
  }

  getToken() async {
    if (usernameKey == null) {
      final prefs = await SharedPreferences.getInstance();

      usernameKey = prefs.getString('username_key');
    }

    await dctService.getDictionaryType("QST-001");
    await dctService.getDictionaryType("FBC-001");
    await dctService.getDictionaryType("ATT-001");
    await dctService.getDictionaryType("SLC-001");
    token = await FirebaseMessaging.instance.getToken();
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

    Widget getItem(Widget destination) {
      return GetMaterialApp(
        translations: Dictionaries(),
        locale: Locale(langCode, countryCode),
        fallbackLocale: Locale(langCode, countryCode),
        debugShowCheckedModeBanner: false,
        title: 'Mi-FIK',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: textTheme,
        ),
        getPages: PageRoutes.pages,
        home: destination,
      );
    }

    if (widget.signed) {
      return FutureBuilder<String>(
        future: FirebaseMessaging.instance.getToken(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            String tokens = snapshot.data;
            userService.putFirebase(tokens);

            if (widget.finishRegis) {
              isShownLostSessPop = false;
              return getItem(const BottomBar());
            } else {
              indexRegis = 5;
              return getItem(const RegisterPage(isLogged: true));
              // return getItem(const WaitingPage());
            }
          } else {
            return const LoadingScreen();
          }
        },
      );
    } else {
      return getItem(const LoginPage());
    }
  }
}
