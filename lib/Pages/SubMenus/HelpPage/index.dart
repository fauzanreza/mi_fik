import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Bars/bottom_bar.dart';
import 'package:mi_fik/Components/Bars/top_bar.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/SubMenus/HelpPage/Components/get_all_help_type.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({Key key}) : super(key: key);

  @override
  StateHelpPage createState() => StateHelpPage();
}

class StateHelpPage extends State<HelpPage> {
  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    //double fullWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: getAppbar("Help", () {
        Get.to(() => const BottomBar());
      }),
      body: const GetAllHelpType(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: successBG,
        tooltip: "Ask a question".tr,
        child: const Icon(Icons.headset_mic),
      ),
    );
  }
}
