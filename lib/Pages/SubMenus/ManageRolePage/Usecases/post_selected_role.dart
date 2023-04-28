import 'package:flutter/material.dart';
import 'package:mi_fik/Components/Forms/tag_picker.dart';
import 'package:mi_fik/Components/Typography/title.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class PostSelectedRole extends StatefulWidget {
  const PostSelectedRole({Key key}) : super(key: key);

  @override
  _PostSelectedRole createState() => _PostSelectedRole();
}

class _PostSelectedRole extends State<PostSelectedRole> {
  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return ListView(
      children: <Widget>[
        Container(
          alignment: Alignment.topRight,
          child: IconButton(
            icon: const Icon(Icons.close),
            tooltip: 'Back',
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        Container(
            padding: EdgeInsets.only(left: paddingMD),
            child: getSubTitleMedium("Selected Role", primaryColor)),
        TagSelectedArea(tag: selectedRole, type: "role")
      ],
    );
  }
}
