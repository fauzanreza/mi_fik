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
    // double fullWidth = MediaQuery.of(context).size.width;
    double fullHeight = MediaQuery.of(context).size.height;

    return ListView(
      children: [
        Container(
          height: fullHeight * 0.75,
          padding: EdgeInsets.all(paddingMD),
          margin:
              EdgeInsets.fromLTRB(paddingMD, paddingLg, paddingMD, paddingMD),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: whitebg,
            boxShadow: [
              BoxShadow(
                color:
                    const Color.fromARGB(255, 128, 128, 128).withOpacity(0.3),
                blurRadius: 10.0,
                spreadRadius: 1.0,
                offset: const Offset(
                  5.0,
                  5.0,
                ),
              )
            ],
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            getTitleLarge("Terms & Condition", primaryColor),
            Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Aliquet nec ullamcorper sit amet risus nullam eget felis. Nibh tellus molestie nunc non blandit massa enim. Dolor magna eget est lorem ipsum dolor sit amet. Maecenas ultricies mi eget mauris pharetra et ultrices. Purus sit amet volutpat consequat mauris nunc congue. Sed cras ornare arcu dui vivamus arcu felis bibendum ut. Mi ipsum faucibus vitae aliquet. Viverra justo nec ultrices dui sapien eget mi proin sed. Enim nulla aliquet porttitor lacus.",
                style: TextStyle(fontSize: textMD - 2)),
            SizedBox(height: paddingMD),
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
              Text("I agree to the terms and condition on this app",
                  style: TextStyle(fontSize: textMD - 2))
            ]),
            getInputWarning(widget.checkMsg),
          ]),
        )
      ],
    );
  }
}
