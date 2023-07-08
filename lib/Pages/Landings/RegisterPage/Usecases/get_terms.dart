import 'package:flutter/material.dart';
import 'package:mi_fik/Components/Typography/title.dart';
import 'package:mi_fik/Modules/Helpers/generator.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class GetTerms extends StatefulWidget {
  const GetTerms({Key key, this.checkMsg}) : super(key: key);
  final String checkMsg;

  @override
  StateGetTerms createState() => StateGetTerms();
}

class StateGetTerms extends State<GetTerms> {
  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return primaryColor;
  }

  @override
  Widget build(BuildContext context) {
    double fullWidth = MediaQuery.of(context).size.width;
    //double fullHeight = MediaQuery.of(context).size.height;

    return ListView(
      padding:
          EdgeInsets.fromLTRB(spaceLG, spaceJumbo + spaceMD, spaceLG, spaceLG),
      children: [
        getTitleLarge("Terms & Condition", primaryColor),
        Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Aliquet nec ullamcorper sit amet risus nullam eget felis. Nibh tellus molestie nunc non blandit massa enim. Dolor magna eget est lorem ipsum dolor sit amet. Maecenas ultricies mi eget mauris pharetra et ultrices. Purus sit amet volutpat consequat mauris nunc congue. Sed cras ornare arcu dui vivamus arcu felis bibendum ut. Mi ipsum faucibus vitae aliquet. Viverra justo nec ultrices dui sapien eget mi proin sed. Enim nulla aliquet porttitor lacus.",
            style: TextStyle(fontSize: textMD - 2)),
        SizedBox(height: spaceLG),
        Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Aliquet nec ullamcorper sit amet risus nullam eget felis. Nibh tellus molestie nunc non blandit massa enim. Dolor magna eget est lorem ipsum dolor sit amet. Maecenas ultricies mi eget mauris pharetra et ultrices. Purus sit amet volutpat consequat mauris nunc congue. Sed cras ornare arcu dui vivamus arcu felis bibendum ut. Mi ipsum faucibus vitae aliquet. Viverra justo nec ultrices dui sapien eget mi proin sed. Enim nulla aliquet porttitor lacus.",
            style: TextStyle(fontSize: textMD - 2)),
        Row(children: [
          Checkbox(
            checkColor: Colors.white,
            fillColor: MaterialStateProperty.resolveWith(getColor),
            value: isCheckedRegister,
            onChanged: (bool value) {
              setState(() {
                isCheckedRegister = value;
              });
            },
          ),
          Container(
              constraints: BoxConstraints(maxWidth: fullWidth * 0.6),
              margin: EdgeInsets.only(top: spaceSM),
              child: Text("I agree to the terms and condition on this app",
                  style: TextStyle(fontSize: textMD - 2.5)))
        ]),
        getInputWarning(widget.checkMsg),
      ],
    );
  }
}
