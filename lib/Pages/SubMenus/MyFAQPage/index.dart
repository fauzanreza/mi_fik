import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Bars/top_bar.dart';
import 'package:mi_fik/Modules/Routes/collection.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/SubMenus/FAQPage/Components/post_question.dart';
import 'package:mi_fik/Pages/SubMenus/MyFAQPage/Components/get_my_faq.dart';

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

    return WillPopScope(
        onWillPop: () {
          Get.toNamed(CollectionRoute.profile, preventDuplicates: false);
          return null;
        },
        child: Scaffold(
          appBar: getAppbar("My Question".tr, () {
            Get.toNamed(CollectionRoute.profile);
          }),
          body: const GetMyFAQ(),
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
                      return const PostQuestion(from: "myfaq");
                    },
                  ),
              backgroundColor: successBG,
              tooltip: "Ask a question".tr,
              child: const Icon(Icons.headset_mic)),
        ));
  }
}
