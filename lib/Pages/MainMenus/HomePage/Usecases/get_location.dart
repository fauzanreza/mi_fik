import 'package:flutter/material.dart';
import 'package:mi_fik/Modules/Helpers/converter.dart';
import 'package:mi_fik/Modules/Helpers/generator.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class GetLocation extends StatefulWidget {
  const GetLocation({Key key}) : super(key: key);

  @override
  _GetLocation createState() => _GetLocation();
}

class _GetLocation extends State<GetLocation> {
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            child: Icon(
              Icons.location_on_outlined,
              size: 20,
              color: whitebg,
            ),
          ),
          TextSpan(
            text: " $locName",
            style: TextStyle(color: whitebg, fontSize: textMD + 2),
          ),
        ],
      ),
    );
  }
}
