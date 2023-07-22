import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class NoDataDialog extends StatelessWidget {
  const NoDataDialog({Key key, this.text}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return AlertDialog(
      contentPadding: EdgeInsets.all(spaceSM),
      title: Text('Warning'.tr, style: TextStyle(fontSize: textXMD)),
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
                child: Image.asset('assets/icon/nodata.png',
                    width: fullWidth * 0.45),
              ),
              Container(
                  margin: EdgeInsets.symmetric(vertical: spaceSM),
                  child: Text(text,
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
