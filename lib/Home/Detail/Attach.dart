import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mi_fik/main.dart';
import 'package:url_launcher/url_launcher.dart';

class AttachButton extends StatefulWidget {
  AttachButton({key, this.passAttach});
  String passAttach;

  @override
  _AttachButton createState() => _AttachButton();
}

class _AttachButton extends State<AttachButton> {
  @override
  Widget build(BuildContext context) {
    final jsonAtt = json.decode(widget.passAttach);
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
                    recognizer: new TapGestureRecognizer()
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
                    recognizer: new TapGestureRecognizer()
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
          //Do something
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

  @override
  void dispose() {
    super.dispose();
  }
}
