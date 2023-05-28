import 'package:flutter/material.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class SuccessDialog extends StatelessWidget {
  SuccessDialog({Key key, this.text}) : super(key: key);
  String text;

  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return AlertDialog(
      contentPadding: const EdgeInsets.all(10),
      title: const Text('Information'),
      content: SizedBox(
        width: fullWidth,
        height: 180,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: Image.asset('assets/icon/Success.png', width: 120),
              ),
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(text,
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
