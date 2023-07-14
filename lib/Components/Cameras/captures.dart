import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:mi_fik/Components/Bars/top_bar.dart';
import 'package:mi_fik/Components/Cameras/preview.dart';
import 'package:mi_fik/Modules/Routes/collection.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key key, this.camera, this.from}) : super(key: key);
  final CameraDescription camera;
  final String from;

  @override
  State<CameraPage> createState() => StateCameraPageState();
}

class StateCameraPageState extends State<CameraPage>
    with SingleTickerProviderStateMixin {
  CameraController cameraCtrl;
  Future<void> initControlFuture;
  AnimationController lottieController;

  @override
  void initState() {
    super.initState();
    cameraCtrl = CameraController(widget.camera, ResolutionPreset.medium);
    initControlFuture = cameraCtrl.initialize();
    lottieController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    cameraCtrl.dispose(); // Dispose the camera controller
    lottieController.dispose();
    super.dispose();
  }

  Future<XFile> captureImage() async {
    try {
      cameraCtrl.setFlashMode(flashMode);
      final imageFile = await cameraCtrl.takePicture();
      return imageFile;
    } catch (e) {
      throw Exception("Failed to capture image");
    }
  }

  void navigateToShowImage(XFile imageFile) {
    Get.to(() => ShowImage(path: imageFile.path, from: widget.from));
  }

  @override
  Widget build(BuildContext context) {
    double fullWidth = MediaQuery.of(context).size.width;
    double fullHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: getAppbar("Take a Picture".tr, () {
        if (widget.from == "profile") {
          Get.toNamed(CollectionRoute.profile, preventDuplicates: false);
        } else if (widget.from == "addpost") {
          Get.toNamed(CollectionRoute.addpost, preventDuplicates: false);
        } else if (widget.from == "register") {
          Get.toNamed(CollectionRoute.register, preventDuplicates: false);
        }
      }),
      body: FutureBuilder<void>(
        future: initControlFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            lottieController.reset();
            return Center(
                child: SizedBox(
                    width: fullWidth,
                    height: fullHeight,
                    child: CameraPreview(cameraCtrl)));
          } else {
            return Center(
                child: Lottie.asset(
              "assets/json/loading-att.json",
              controller: lottieController,
              width: 200,
              filterQuality: FilterQuality.low,
              onLoaded: (composition) {
                lottieController
                  ..duration = composition.duration
                  ..forward();
              },
            ));
          }
        },
      ),
      floatingActionButton: Container(
          height: 160,
          margin: EdgeInsets.only(bottom: spaceLG),
          child: Column(children: [
            FloatingActionButton(
              backgroundColor: primaryColor,
              onPressed: () async {
                try {
                  final imageFile = await captureImage();
                  navigateToShowImage(imageFile);
                } catch (e) {
                  Get.snackbar(
                    "Error".tr,
                    "Failed to capture image".tr,
                    backgroundColor: primaryColor,
                  );
                }
              },
              child: const Icon(Icons.camera_alt),
            ),
            SizedBox(height: spaceLG),
            FloatingActionButton(
              backgroundColor: infoBG,
              onPressed: () {
                setState(() {
                  if (flashMode == FlashMode.off) {
                    Get.snackbar("Alert".tr, "Flash is switch on",
                        backgroundColor: whiteColor);
                    flashMode = FlashMode.torch;
                  } else {
                    Get.snackbar("Alert".tr, "Flash is switch off",
                        backgroundColor: whiteColor);
                    flashMode = FlashMode.off;
                  }
                });
              },
              child: Icon(flashMode == FlashMode.off
                  ? Icons.flash_off
                  : Icons.flash_on),
            )
          ])),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
