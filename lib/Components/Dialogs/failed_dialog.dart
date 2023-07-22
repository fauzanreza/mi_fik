import 'package:flutter/material.dart';
import 'package:mi_fik/Modules/Helpers/converter.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class FailedDialog extends StatefulWidget {
  const FailedDialog({Key key, this.text, this.type}) : super(key: key);
  // ignore: prefer_typing_uninitialized_variables
  final text; // Can be string or list
  final String type;

  @override
  StateFailedDialog createState() => StateFailedDialog();
}

class StateFailedDialog extends State<FailedDialog> {
  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return AlertDialog(
      contentPadding: EdgeInsets.all(spaceSM),
      title: Text('Error', style: TextStyle(fontSize: textXMD)),
      content: SizedBox(
        width: fullWidth,
        height: 210,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(roundedJumbo + roundedJumbo),
                child: Image.asset('assets/icon/Failed.png', width: 120),
              ),
              Container(
                  margin: EdgeInsets.symmetric(vertical: spaceSM),
                  child: Text(
                      getMessageResponseFromObject(widget.text, widget.type),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: shadowColor, fontSize: textXMD)))
            ]),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: Text('OK', style: TextStyle(fontSize: textXMD)),
        ),
      ],
    );
  }
}
