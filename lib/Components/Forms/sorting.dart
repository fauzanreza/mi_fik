import 'package:flutter/material.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class SortingButton extends StatelessWidget {
  final String active;
  final Function(String) action;

  const SortingButton({Key key, this.active, this.action}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return active == "DESC"
        ? TextButton(
            style: TextButton.styleFrom(
              backgroundColor: primaryColor,
              shape: const CircleBorder(),
            ),
            onPressed: () => action("ASC"),
            child: Icon(
              Icons.arrow_downward_rounded,
              color: whitebg,
            ),
          )
        : TextButton(
            style: TextButton.styleFrom(
              backgroundColor: primaryColor,
              shape: const CircleBorder(),
            ),
            onPressed: () => action("DESC"),
            child: Icon(
              Icons.arrow_upward_rounded,
              color: whitebg,
            ),
          );
  }
}
