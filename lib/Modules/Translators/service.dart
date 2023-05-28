import 'dart:ui';

import 'package:get/get.dart';

class LangCtrl extends GetxController {
  void switchLang(var code, var country) {
    var locale = Locale(code, country);
    Get.updateLocale(locale);
  }
}
