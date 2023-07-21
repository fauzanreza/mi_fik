import 'package:get/get.dart';
import 'package:mi_fik/Components/Bars/bottom_bar.dart';
import 'package:mi_fik/Modules/Routes/collection.dart';
import 'package:mi_fik/Modules/Routes/middleware.dart';
import 'package:mi_fik/Pages/Landings/ForgetPassPage/index.dart';
import 'package:mi_fik/Pages/Landings/LoginPage/index.dart';
import 'package:mi_fik/Pages/Landings/RegisterPage/index.dart';
import 'package:mi_fik/Pages/MainMenus/CalendarPage/index.dart';
import 'package:mi_fik/Pages/MainMenus/HomePage/index.dart';
import 'package:mi_fik/Pages/MainMenus/SchedulePage/index.dart';
import 'package:mi_fik/Pages/SubMenus/AboutPage/index.dart';
import 'package:mi_fik/Pages/SubMenus/AddPostPage/index.dart';
import 'package:mi_fik/Pages/SubMenus/FAQPage/index.dart';
import 'package:mi_fik/Pages/SubMenus/HelpPage/index.dart';
import 'package:mi_fik/Pages/SubMenus/HistoryPage/index.dart';
import 'package:mi_fik/Pages/SubMenus/ManageRolePage/index.dart';
import 'package:mi_fik/Pages/SubMenus/MyFAQPage/index.dart';
import 'package:mi_fik/Pages/SubMenus/ProfilePage/index.dart';
import 'package:mi_fik/Pages/SubMenus/SettingPage/index.dart';
import 'package:mi_fik/Pages/SubMenus/TrashPage/index.dart';

class PageRoutes {
  static final pages = [
    GetPage(name: CollectionRoute.landing, page: () => const LoginPage()),
    GetPage(name: CollectionRoute.register, page: () => const RegisterPage()),
    GetPage(name: CollectionRoute.forget, page: () => const ForgetPage()),
    GetPage(
        name: CollectionRoute.profile,
        page: () => const ProfilePage(),
        middlewares: [RouteGuard()]),
    GetPage(
        name: CollectionRoute.myfaq,
        page: () => const MyFAQPage(),
        middlewares: [RouteGuard()]),
    GetPage(
        name: CollectionRoute.faq,
        page: () => const FAQPage(),
        middlewares: [RouteGuard()]),
    GetPage(
        name: CollectionRoute.history,
        page: () => const HistoryPage(),
        middlewares: [RouteGuard()]),
    GetPage(
        name: CollectionRoute.about,
        page: () => const AboutPage(),
        middlewares: [RouteGuard()]),
    GetPage(
        name: CollectionRoute.role,
        page: () => const RolePage(),
        middlewares: [RouteGuard()]),
    GetPage(
        name: CollectionRoute.help,
        page: () => const HelpPage(),
        middlewares: [RouteGuard()]),
    GetPage(
        name: CollectionRoute.setting,
        page: () => const SettingPage(),
        middlewares: [RouteGuard()]),
    GetPage(
        name: CollectionRoute.addpost,
        page: () => const AddPost(),
        middlewares: [RouteGuard()]),
    GetPage(
        name: CollectionRoute.homepage,
        page: () => const HomePage(),
        middlewares: [RouteGuard()]),
    GetPage(
        name: CollectionRoute.calendar,
        page: () => const CalendarPage(),
        middlewares: [RouteGuard()]),
    GetPage(
        name: CollectionRoute.schedule,
        page: () => const SchedulePage(),
        middlewares: [RouteGuard()]),
    GetPage(
        name: CollectionRoute.trash,
        page: () => const TrashPage(),
        middlewares: [RouteGuard()]),
    GetPage(
        name: CollectionRoute.bar,
        page: () => const BottomBar(),
        middlewares: [RouteGuard()]),
  ];
}
