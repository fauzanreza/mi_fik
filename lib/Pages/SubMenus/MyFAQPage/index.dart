import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Bars/top_bar.dart';
import 'package:mi_fik/Pages/SubMenus/FAQPage/Usecases/post_question.dart';
import 'package:mi_fik/Pages/SubMenus/MyFAQPage/Usecases/get_my_faq.dart';
import 'package:mi_fik/Pages/SubMenus/ProfilePage/index.dart';

class MyFAQPage extends StatefulWidget {
  const MyFAQPage({Key key}) : super(key: key);

  @override
  _MyFAQPage createState() => _MyFAQPage();
}

class _MyFAQPage extends State<MyFAQPage> {
  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    //double fullWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: getAppbar("My Question".tr, () {
          Get.to(() => const ProfilePage());
        }),
        body: const GetMyFAQ(),
        floatingActionButton: PostQuestion(from: "myfaq"));
  }
}
