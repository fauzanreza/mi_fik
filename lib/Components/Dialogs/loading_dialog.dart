import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingDialog extends StatefulWidget {
  const LoadingDialog({Key key, this.url, this.ctrl}) : super(key: key);
  final String url;
  final AnimationController ctrl;
  @override
  StateLoadingDialog createState() => StateLoadingDialog();
}

class StateLoadingDialog extends State<LoadingDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        contentPadding: EdgeInsets.zero,
        elevation: 0,
        backgroundColor: Colors.transparent,
        content: Lottie.asset(
          widget.url,
          controller: widget.ctrl,
          filterQuality: FilterQuality.low,
          onLoaded: (composition) {
            widget.ctrl
              ..duration = composition.duration
              ..forward();
          },
        ));
  }
}
