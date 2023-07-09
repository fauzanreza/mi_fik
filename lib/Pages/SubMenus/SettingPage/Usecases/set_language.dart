import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Dialogs/success_dialog.dart';
import 'package:mi_fik/Components/Typography/title.dart';
import 'package:mi_fik/Modules/Translators/service.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetLanguage extends StatefulWidget {
  const SetLanguage({Key key}) : super(key: key);

  @override
  StateSetLanguage createState() => StateSetLanguage();
}

class StateSetLanguage extends State<SetLanguage> {
  LangCtrl langctrl = Get.put(LangCtrl());
  LangList slctLang = LangList.en;

  getActiveLang() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getString("lang_key") == "id") {
      slctLang = LangList.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    getActiveLang();
    //double fullHeight = MediaQuery.of(context).size.height;
    //double fullWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.all(spaceLG),
      margin: EdgeInsets.all(spaceXMD),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: whiteColor),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        getSubTitleMedium("Language".tr, darkColor, TextAlign.start),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text('English', style: TextStyle(fontSize: textMD)),
          leading: Radio<LangList>(
            value: LangList.en,
            groupValue: slctLang,
            onChanged: (LangList value) async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('lang_key', "en");

              setState(() {
                slctLang = value;
                langctrl.switchLang('en', 'US');
                Get.dialog(
                    const SuccessDialog(text: "Language changed to English"));
              });
            },
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text('Bahasa Indonesia', style: TextStyle(fontSize: textMD)),
          leading: Radio<LangList>(
            value: LangList.id,
            groupValue: slctLang,
            onChanged: (LangList value) async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('lang_key', "id");

              setState(() {
                slctLang = value;
                langctrl.switchLang('id', 'ID');
                Get.dialog(const SuccessDialog(
                    text: "Bahasa diganti ke bahasa Indonesia"));
              });
            },
          ),
        ),
      ]),
    );
  }
}
