import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:mi_fik/Pages/SubMenus/ProfilePage/index.dart';

class LoadingDialog extends StatefulWidget {
  const LoadingDialog({Key key, this.url, this.destination}) : super(key: key);
  final String url;
  final String destination;
  @override
  StateLoadingDialog createState() => StateLoadingDialog();
}

class StateLoadingDialog extends State<LoadingDialog>
    with SingleTickerProviderStateMixin {
  AnimationController lottieController;

  @override
  void initState() {
    super.initState();
    lottieController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // double fullHeight = MediaQuery.of(context).size.height;
    // double fullWidth = MediaQuery.of(context).size.width;

    return AlertDialog(
        contentPadding: EdgeInsets.zero,
        elevation: 0,
        backgroundColor: Colors.transparent,
        content: Lottie.asset(
          widget.url,
          controller: lottieController,
          filterQuality: FilterQuality.low,
          onLoaded: (composition) {
            lottieController
              ..duration = composition.duration
              ..forward().whenComplete(() {
                lottieController.reset();
                if (widget.destination == 'profile') {
                  Get.offAll(() => const ProfilePage());
                }
              });
          },
        ));
  }
}
