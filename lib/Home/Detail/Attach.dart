import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mi_fik/main.dart';
import 'package:url_launcher/url_launcher.dart';

class AttachButton extends StatelessWidget {
  AttachButton({Key key, this.passAttach}) : super(key: key);
  String passAttach;

  @override
  Widget build(BuildContext context) {
    double fullWidth = MediaQuery.of(context).size.width;
    final jsonAtt = json.decode(passAttach);
    //final jsonAtt = json.encode(widget.passAttach);

    return Column(
        children: jsonAtt.map<Widget>((attach) {
      //Get button text by name or url.
      getButtonText(attach) {
        if (attach['attach_name'] != "") {
          return attach['attach_name'];
        } else {
          return attach['attach_url'];
        }
      }

      //Get button attachment by its type.
      Widget getButton() {
        if (attach['type'] == "youtube") {
          return RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                  child: Icon(
                      Icons
                          .video_collection_outlined, //Change if there's an asset.
                      size: iconMD,
                      color: primaryColor),
                ),
                TextSpan(
                    text: getButtonText(attach),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launchUrl(Uri.parse(attach['attach_url'].toString()));
                      },
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: blackbg,
                        fontSize: textSM)),
              ],
            ),
          );
        } else if (attach['type'] == "pdf") {
          return RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                  child: Icon(Icons.picture_as_pdf_outlined,
                      size: iconMD, color: primaryColor),
                ),
                TextSpan(
                    text: getButtonText(attach),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launchUrl(Uri.parse(attach['attach_url'].toString()));
                      },
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: blackbg,
                        fontSize: textSM)),
              ],
            ),
          );
        } else if (attach['type'] == "image") {
          return SizedBox(
            width: fullWidth * 0.8,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(roundedMd2),
                  child: Image.network(attach['attach_url'].toString()),
                ),
                const SizedBox(height: 5),
                Text(attach['attach_name'].toString(),
                    style: TextStyle(
                        fontSize: textSM,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic))
              ],
            ),
          );
        } else if (attach['type'] == "video") {
          //Do something.
        } else if (attach['type'] == "undefined") {
          //Other link.
        }
      }

      return Container(
          margin: EdgeInsets.only(left: marginMD, top: marginMD),
          alignment: Alignment.centerLeft,
          child: getButton());
    }).toList());
  }
}
