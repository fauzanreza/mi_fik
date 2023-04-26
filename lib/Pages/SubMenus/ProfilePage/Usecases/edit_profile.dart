import 'package:flutter/material.dart';
import 'package:mi_fik/Components/Forms/input.dart';
import 'package:mi_fik/Modules/Helpers/validation.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class GetEditProfile extends StatefulWidget {
  const GetEditProfile({Key key}) : super(key: key);

  @override
  State<GetEditProfile> createState() => _GetEditProfileState();
}

class _GetEditProfileState extends State<GetEditProfile> {
  var fNameCtrl = TextEditingController();
  var lNameCtrl = TextEditingController();
  var passCtrl = TextEditingController();

  @override
  void dispose() {
    fNameCtrl.dispose();
    lNameCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  void _refreshPage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context).copyWith(
          dividerColor:
              Colors.transparent, // set the divider color to transparent
        ),
        child: SingleChildScrollView(
            child: ExpansionTile(
                childrenPadding: EdgeInsets.only(
                    left: paddingSM, bottom: paddingSM, right: paddingSM),
                initiallyExpanded: false,
                trailing: Container(
                  decoration: BoxDecoration(
                      color: infoColor,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(100))),
                  width: 48.0,
                  height: 48.0,
                  child: IconButton(
                    icon: Icon(Icons.edit, color: whitebg),
                  ),
                ),
                iconColor: null,
                textColor: whitebg,
                collapsedTextColor: primaryColor,
                leading: null,
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                expandedAlignment: Alignment.topLeft,
                title: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 5, vertical: paddingSM),
                    child: Text("Edit Profile",
                        style: TextStyle(
                            fontSize: textMD + 4,
                            fontWeight: FontWeight.w500))),
                children: [
              getInputText(fnameLength, fNameCtrl, false),
              getInputText(lnameLength, lNameCtrl, false),
              getInputText(passwordLength, passCtrl, true)
            ])));
  }
}