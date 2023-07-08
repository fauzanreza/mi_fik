import 'package:flutter/material.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({Key key, this.text}) : super(key: key);
  final String text;

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
                borderRadius:
                    BorderRadius.circular(roundedJumbo + roundedJumbo),
                child: Image.asset('assets/icon/Success.png', width: 120),
              ),
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(text,
                      style: TextStyle(
                          color: shadowColor,
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

class SuccessDialogCustom extends StatelessWidget {
  const SuccessDialogCustom({Key key, this.text}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return AlertDialog(
        contentPadding: EdgeInsets.zero,
        elevation: 0,
        backgroundColor: Colors.transparent,
        content: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            width: fullWidth * 0.45,
            padding: EdgeInsets.all(fullWidth * 0.1),
            margin: EdgeInsets.only(bottom: spaceMD),
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              child: Image.asset('assets/icon/checklist.png'),
            ),
          ),
          Text(text,
              style: TextStyle(
                  color: whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: textXMD))
        ]));
  }
}
