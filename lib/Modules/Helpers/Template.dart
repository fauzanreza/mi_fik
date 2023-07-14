import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:mi_fik/Modules/Routes/collection.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

getDBDateFormat(type, date) {
  if (type == "date" && type != null && date != null) {
    return DateFormat("yyyy-MM-dd").format(date);
  } else if (type == "time" && type != null && date != null) {
    return DateFormat("HH:mm").format(date);
  }
}

getDestroyTrace(bool isSignOut) async {
  final prefs = await SharedPreferences.getInstance();
  GetStorage box = GetStorage();

  await prefs.clear();
  await box.erase();
  final cacheDir = await getTemporaryDirectory();
  final appDir = await getApplicationSupportDirectory();

  if (appDir.existsSync()) {
    appDir.deleteSync(recursive: true);
  }

  if (cacheDir.existsSync()) {
    cacheDir.deleteSync(recursive: true);
  }

  Get.reset();
  Get.clearRouteTree();
  Get.offAllNamed(CollectionRoute.landing);

  if (!isSignOut) {
    Get.snackbar("Alert".tr, "Session lost, please sign in again".tr,
        backgroundColor: whiteColor);
  }
}
