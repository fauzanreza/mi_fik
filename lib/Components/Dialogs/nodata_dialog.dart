import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class NoDataDialog extends StatelessWidget {
  NoDataDialog({Key key, this.text}) : super(key: key);
  String text;

  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return AlertDialog(
      contentPadding: const EdgeInsets.all(10),
      title: Text('Warning'.tr),
      content: SizedBox(
        width: fullWidth,
        height: 210,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: Image.asset('assets/icon/nodata.png',
                    width: fullWidth * 0.45),
              ),
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(text,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: greybg, fontSize: textMD)))
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
