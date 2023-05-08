import 'package:flutter/material.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class LocationTitle extends StatelessWidget {
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
            text: " :",
            style: TextStyle(color: whitebg),
          ),
        ],
      ),
    );
  }
}
