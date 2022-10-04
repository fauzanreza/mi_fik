import 'package:flutter/material.dart';
import 'package:mi_fik/DB/Database.dart';
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
  //Initial variable
  var db = Mysql();
  bool isChecked = false;

  //Controller
  Future checkArchieve() async {
    db.getConnection().then((conn) {
      String sql =
          "SELECT * FROM archieve_relation where archieve_id = ${widget.idArchieve} AND content_id = ${widget.idContent} AND user_id = 1";
      conn.query(sql).then((results) {
        for (var row in results) {
          setState(() {
            isChecked = true;
          });
        }
      });
      conn.close();
    });
  }

  @override
  void initState() {
    super.initState();
    checkArchieve();
  }

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

          archieveVal.add(widget.idArchieve);
        });
      },
    );
  }
}
