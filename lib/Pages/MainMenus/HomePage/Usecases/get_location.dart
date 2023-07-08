import 'package:flutter/material.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class GetLocation extends StatefulWidget {
  const GetLocation({Key key}) : super(key: key);

  @override
  StateGetLocation createState() => StateGetLocation();
}

class StateGetLocation extends State<GetLocation> {
  @override
  Widget build(BuildContext context) {
    getLocationNull(String val) {
      if (val == "null" || val == null) {
        return " Not found";
      } else {
        return " $val";
      }
    }

    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            child: Icon(
              Icons.location_on_outlined,
              size: iconMD,
              color: whiteColor,
            ),
          ),
          TextSpan(
            text: getLocationNull(locName),
            style: TextStyle(color: whiteColor, fontSize: textXMD),
          ),
        ],
      ),
    );
  }
}
