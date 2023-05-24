import 'package:chewie/chewie.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class AttachButton extends StatefulWidget {
  AttachButton({Key key, this.passAttach}) : super(key: key);
  var passAttach;

  @override
  _AttachButton createState() => _AttachButton();
}

class _AttachButton extends State<AttachButton> {
  final VideoPlayerController _controller = VideoPlayerController.network(
    'https://firebasestorage.googleapis.com/v0/b/mifik-ad2d9.appspot.com/o/attachment_video%2F9ba74548-a6ec-497b-b943-64dcb77c578c?alt=media&token=72ec5618-2fd2-4596-abf8-2f6b06513b42',
  );

  @override
  Widget build(BuildContext context) {
    double fullWidth = MediaQuery.of(context).size.width;

    return Column(
        children: widget.passAttach.map<Widget>((attach) {
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
        if (attach['attach_type'] == "attachment_url") {
          return RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                  child: Icon(Icons.link, size: iconMD, color: primaryColor),
                ),
                TextSpan(
                    text: " ${getButtonText(attach)}",
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launchUrl(Uri.parse(attach['attach_url'].toString()));
                      },
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: blackbg,
                        fontSize: textSM + 2)),
              ],
            ),
          );
        } else if (attach['attach_type'] == "attachment_image") {
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
        } else if (attach['attach_type'] == "attachment_video") {
          //Do something.

          return Chewie(
            controller: ChewieController(
              videoPlayerController: _controller,
              autoPlay: true,
              looping: true,
            ),
          );
        }
      }

      return Container(
          margin: EdgeInsets.only(left: marginMD, top: marginMD * 0.3),
          alignment: Alignment.centerLeft,
          child: getButton());
    }).toList());
  }
}
