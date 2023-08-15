import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Bars/bottom_bar.dart';
import 'package:mi_fik/Components/Bars/top_bar.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/SubMenus/FAQPage/Components/get_question.dart';
import 'package:mi_fik/Pages/SubMenus/FAQPage/Components/post_question.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({Key key}) : super(key: key);

  @override
  StateFAQPage createState() => StateFAQPage();
}

class StateFAQPage extends State<FAQPage> {
  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    //double fullWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: getAppbar("Frequently Asked Question".tr, () {
        Get.to(() => const BottomBar());
      }),
      body: const GetAllQuestion(),
      floatingActionButton: FloatingActionButton(
          onPressed: () => showModalBottomSheet(
                context: context,
                isDismissible: false,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(roundedLG),
                        topRight: Radius.circular(roundedLG))),
                barrierColor: primaryColor.withOpacity(0.5),
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return const PostQuestion(from: "faq");
                },
              ),
          backgroundColor: successBG,
          tooltip: "Ask a question".tr,
          child: const Icon(Icons.headset_mic)),
    );
  }
}
