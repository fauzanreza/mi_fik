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

class PageRoutes {
  static final pages = [
    GetPage(
        name: CollectionRoute.landing,
        page: () => const LoginPage(),
        transition: Transition.noTransition),
    GetPage(
        name: CollectionRoute.register,
        page: () => const RegisterPage(),
        transition: Transition.noTransition),
    GetPage(
        name: CollectionRoute.forget,
        page: () => const ForgetPage(),
        transition: Transition.noTransition),
    GetPage(
        name: CollectionRoute.profile,
        page: () => const ProfilePage(),
        middlewares: [RouteGuard()],
        transition: Transition.noTransition),
    GetPage(
        name: CollectionRoute.myfaq,
        page: () => const MyFAQPage(),
        middlewares: [RouteGuard()],
        transition: Transition.noTransition),
    GetPage(
        name: CollectionRoute.faq,
        page: () => const FAQPage(),
        middlewares: [RouteGuard()],
        transition: Transition.noTransition),
    GetPage(
        name: CollectionRoute.history,
        page: () => const HistoryPage(),
        middlewares: [RouteGuard()],
        transition: Transition.noTransition),
    GetPage(
        name: CollectionRoute.about,
        page: () => const AboutPage(),
        middlewares: [RouteGuard()],
        transition: Transition.noTransition),
    GetPage(
        name: CollectionRoute.role,
        page: () => const RolePage(),
        middlewares: [RouteGuard()],
        transition: Transition.noTransition),
    GetPage(
        name: CollectionRoute.help,
        page: () => const HelpPage(),
        middlewares: [RouteGuard()],
        transition: Transition.noTransition),
    GetPage(
        name: CollectionRoute.setting,
        page: () => const SettingPage(),
        middlewares: [RouteGuard()],
        transition: Transition.noTransition),
    GetPage(
        name: CollectionRoute.addpost,
        page: () => const AddPost(),
        middlewares: [RouteGuard()],
        transition: Transition.noTransition),
    GetPage(
        name: CollectionRoute.homepage,
        page: () => const HomePage(),
        middlewares: [RouteGuard()],
        transition: Transition.noTransition),
    GetPage(
        name: CollectionRoute.calendar,
        page: () => const CalendarPage(),
        middlewares: [RouteGuard()],
        transition: Transition.noTransition),
    GetPage(
        name: CollectionRoute.schedule,
        page: () => const SchedulePage(),
        middlewares: [RouteGuard()],
        transition: Transition.noTransition),
    GetPage(
        name: CollectionRoute.bar,
        page: () => const BottomBar(),
        middlewares: [RouteGuard()],
        transition: Transition.noTransition),
  ];
}
