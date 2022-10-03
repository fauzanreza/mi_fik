import 'package:flutter/material.dart';
import 'package:mi_fik/DB/Model/Archieve_Rel_M.dart';
import 'package:mi_fik/main.dart';

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key, this.idArchieve, this.idContent})
      : super(key: key);
  int idArchieve;
  int idContent;

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return primaryColor;
      }
      return Colors.white;
    }

    return Checkbox(
      checkColor: primaryColor,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: isChecked,
      onChanged: (bool value) {
        setState(() {
          isChecked = value;

          archieve.add(ArchieveRel({widget.idArchieve, widget.idContent}));
        });
      },
    );
  }
}
