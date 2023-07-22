import 'package:flutter/material.dart';
import 'package:mi_fik/Components/Typography/title.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/SubMenus/ManageRolePage/Usecases/get_tag_category.dart';

class SetRole extends StatefulWidget {
  const SetRole({Key key}) : super(key: key);

  @override
  StateSetRole createState() => StateSetRole();
}

class StateSetRole extends State<SetRole> {
  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;

    Widget getPicker(bool status) {
      if (status) {
        return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          SizedBox(
            height: spaceJumbo,
          ),
          getSubTitleMedium(
              "You can't request to modify your tag, because you still have awaiting request",
              primaryColor,
              TextAlign.center),
          ClipRRect(
            child:
                Image.asset('assets/icon/sorry.png', width: fullHeight * 0.3),
          ),
          getSubTitleMedium(
              "Please wait some moment or try to contact the Admin",
              darkColor,
              TextAlign.center)
        ]);
      } else {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Expanded(
                  child: GetAllTagCategory(
                isLogged: false,
              ))
            ]);
      }
    }

    return ListView(
      children: [
        Container(
            height: fullHeight * 0.9,
            padding: EdgeInsets.fromLTRB(spaceMD, spaceXMD, spaceMD, spaceMD),
            child: getPicker(isWaiting))
      ],
    );
  }
}
