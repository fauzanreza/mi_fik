import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Dialogs/success_dialog.dart';
import 'package:mi_fik/Components/Typography/title.dart';
import 'package:mi_fik/Modules/Translators/service.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class SetLanguage extends StatefulWidget {
  const SetLanguage({Key key}) : super(key: key);

  @override
  StateSetLanguage createState() => StateSetLanguage();
}

class StateSetLanguage extends State<SetLanguage> {
  LangCtrl langctrl = Get.put(LangCtrl());

  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    //double fullWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.all(paddingMD),
      margin: EdgeInsets.all(paddingSM),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: whitebg),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        getSubTitleMedium("Language".tr, blackbg, TextAlign.start),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('English'),
          leading: Radio<LangList>(
            value: LangList.en,
            groupValue: slctLang,
            onChanged: (LangList value) {
              setState(() {
                langctrl.switchLang('en', 'US');
                slctLang = value;
              });
              showDialog<String>(
                  context: context,
                  builder: (BuildContext context) =>
                      const SuccessDialog(text: "Language changed to English"));
            },
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Bahasa Indonesia'),
          leading: Radio<LangList>(
            value: LangList.id,
            groupValue: slctLang,
            onChanged: (LangList value) {
              setState(() {
                langctrl.switchLang('id', 'ID');
                slctLang = value;
              });
              showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => const SuccessDialog(
                      text: "Bahasa diganti ke bahasa Indonesia"));
            },
          ),
        ),
      ]),
    );
  }
}
