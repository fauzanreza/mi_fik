import 'package:flutter/material.dart';
import 'package:mi_fik/main.dart';

class FailedDialog extends StatefulWidget {
  FailedDialog({Key key, this.text}) : super(key: key);
  String text;

  @override
  _FailedDialog createState() => _FailedDialog();
}

class _FailedDialog extends State<FailedDialog> {
  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return AlertDialog(
      contentPadding: const EdgeInsets.all(10),
      title: const Text('Error'),
      content: SizedBox(
        width: fullWidth,
        height: 210,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: Image.asset('assets/icon/Failed.png', width: 120),
              ),
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(widget.text,
                      style: TextStyle(
                          color: greybg,
                          fontSize: 16,
                          fontWeight: FontWeight.w500)))
            ]),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: const Text('OK'),
        ),
      ],
    );
  }
}