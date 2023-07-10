import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Bars/top_bar.dart';
import 'package:mi_fik/Modules/Routes/collection.dart';
import 'package:mi_fik/Pages/SubMenus/FAQPage/Usecases/post_question.dart';
import 'package:mi_fik/Pages/SubMenus/MyFAQPage/Usecases/get_my_faq.dart';

class MyFAQPage extends StatefulWidget {
  const MyFAQPage({Key key}) : super(key: key);

  @override
  StateMyFAQPage createState() => StateMyFAQPage();
}

class StateMyFAQPage extends State<MyFAQPage> {
  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    //double fullWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: getAppbar("My Question".tr, () {
          Get.toNamed(CollectionRoute.profile);
        }),
        body: const GetMyFAQ(),
        floatingActionButton: const PostQuestion(from: "myfaq"));
  }
}
