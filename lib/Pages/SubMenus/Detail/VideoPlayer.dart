import 'package:chewie/chewie.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class VideoPlayer extends StatefulWidget {
  VideoPlayer({Key key, this.passAttach}) : super(key: key);
  var passAttach;

  @override
  _VideoPlayer createState() => _VideoPlayer();
}

class _VideoPlayer extends State<VideoPlayer> {
  VideoPlayerController _controller;

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
          _controller = attach['attach_url'];

          return SizedBox(
              width: fullWidth * 0.8,
              child: Flexible(
                child: Chewie(
                    controller: ChewieController(
                  videoPlayerController: _controller,
                  autoPlay: false,
                  looping: false,
                  aspectRatio: 16 / 9,
                )),
              ));
        }
      }

      return Container(
          margin: EdgeInsets.only(left: marginMD, top: marginMD * 0.3),
          alignment: Alignment.centerLeft,
          child: getButton());
    }).toList());
  }
}
