import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Backgrounds/image.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';

import 'package:mi_fik/Modules/APIs/HelpApi/Models/queries.dart';
import 'package:mi_fik/Modules/APIs/HelpApi/Services/queries.dart';
import 'package:mi_fik/Modules/Helpers/converter.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/SubMenus/HelpPage/Usecases/get_help_by_type.dart';

class GetAllHelpType extends StatefulWidget {
  const GetAllHelpType({Key key}) : super(key: key);

  @override
  StateGetAllHelpType createState() => StateGetAllHelpType();
}

class StateGetAllHelpType extends State<GetAllHelpType> {
  HelpQueriesService apiQuery;

  @override
  void initState() {
    super.initState();
    apiQuery = HelpQueriesService();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      maintainBottomViewPadding: false,
      child: FutureBuilder(
        future: apiQuery.getHelpType(),
        builder: (BuildContext context,
            AsyncSnapshot<List<HelpTypeModel>> snapshot) {
          if (snapshot.hasError) {
            Get.dialog(const FailedDialog(
                text: "Unknown error, please contact the admin",
                type: "error"));
            return const Center(
              child: Text("Something wrong"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<HelpTypeModel> contents = snapshot.data;
            return _buildListView(contents);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _buildListView(List<HelpTypeModel> contents) {
    // double fullHeight = MediaQuery.of(context).size.height;
    // double fullWidth = MediaQuery.of(context).size.width;

    if (contents != null) {
      return ListView.builder(
          itemCount: contents.length,
          padding: const EdgeInsets.all(10),
          itemBuilder: (context, index) {
            return Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: hoverBG, width: 1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: ExpansionTile(
                initiallyExpanded: false,
                iconColor: primaryColor,
                textColor: primaryColor,
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                expandedAlignment: Alignment.topLeft,
                title: Text(ucFirst(contents[index].helpType),
                    style: TextStyle(
                        fontWeight: FontWeight.w500, fontSize: textMD)),
                subtitle: Text('Lorem ipsum',
                    style: TextStyle(color: shadowColor, fontSize: textMD)),
                children: [GetHelpByType(passType: contents[index].helpType)],
              ),
            );
          });
    } else {
      return getMessageImageNoData("assets/icon/empty.png",
          "Unknown error, please contact the admin".tr, 200);
    }
  }
}
