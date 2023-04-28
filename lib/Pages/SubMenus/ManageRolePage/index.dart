import 'package:flutter/material.dart';
import 'package:mi_fik/Components/Bars/top_bar.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/SubMenus/ManageRolePage/Usecases/get_tag_category.dart';

class RolePage extends StatefulWidget {
  const RolePage({Key key}) : super(key: key);

  @override
  _RolePage createState() => _RolePage();
}

class _RolePage extends State<RolePage> {
  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: getAppbar("Manage Role"),
      body: const GetAllTagCategory(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: successbg,
        tooltip: "Help",
        child: const Icon(Icons.help),
      ),
    );
  }
}
