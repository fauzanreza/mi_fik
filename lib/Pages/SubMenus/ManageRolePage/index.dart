import 'package:flutter/material.dart';
import 'package:mi_fik/Components/Bars/top_bar.dart';
import 'package:mi_fik/Components/Dialogs/nodata_dialog.dart';
import 'package:mi_fik/Components/Typography/title.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/SubMenus/ManageRolePage/Usecases/get_tag_category.dart';
import 'package:mi_fik/Pages/SubMenus/ManageRolePage/Usecases/post_selected_role.dart';

class RolePage extends StatefulWidget {
  const RolePage({Key key}) : super(key: key);

  @override
  _RolePage createState() => _RolePage();
}

class _RolePage extends State<RolePage> {
  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: getAppbar("Manage Role"),
      body: const GetAllTagCategory(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selectedRole.isNotEmpty) {
            showDialog<String>(
                context: context,
                builder: (BuildContext context) =>
                    NoDataDialog(text: "You haven't selected any tag yet"));
          } else {
            showModalBottomSheet<void>(
              context: context,
              isDismissible: false,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: roundedLG, topRight: roundedLG)),
              barrierColor: primaryColor.withOpacity(0.5),
              isScrollControlled: true,
              builder: (BuildContext context) {
                return Container(
                    height: fullHeight * 0.4,
                    padding: MediaQuery.of(context).viewInsets,
                    child: const PostSelectedRole());
              },
            );
          }
        },
        backgroundColor: successbg,
        tooltip: "Submit Chages",
        child: const Icon(Icons.send),
      ),
    );
  }
}
