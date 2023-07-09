import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Bars/top_bar.dart';
import 'package:mi_fik/Components/Cameras/preview.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/Landings/RegisterPage/index.dart';
import 'package:mi_fik/Pages/SubMenus/AddPostPage/index.dart';
import 'package:mi_fik/Pages/SubMenus/ProfilePage/index.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key key, this.camera, this.from}) : super(key: key);
  final CameraDescription camera;
  final String from;

  @override
  State<CameraPage> createState() => StateCameraPageState();
}

class StateCameraPageState extends State<CameraPage> {
  CameraController cameraCtrl;
  Future<void> initControlFuture;

  @override
  void initState() {
    super.initState();
    cameraCtrl = CameraController(widget.camera, ResolutionPreset.medium);
    initControlFuture = cameraCtrl.initialize();
  }

  @override
  void dispose() {
    cameraCtrl.dispose(); // Dispose the camera controller
    super.dispose();
  }

  Future<XFile> captureImage() async {
    try {
      final imageFile = await cameraCtrl.takePicture();
      return imageFile;
    } catch (e) {
      throw Exception("Failed to capture image");
    }
  }

  void navigateToShowImage(XFile imageFile) {
    Get.offAll(() => ShowImage(path: imageFile.path, from: widget.from));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppbar("Take a Picture".tr, () {
        if (widget.from == "profile") {
          Get.offAll(() => const ProfilePage());
        } else if (widget.from == "addpost") {
          Get.offAll(() => const AddPost());
        } else if (widget.from == "register") {
          Get.offAll(() => const RegisterPage());
        }
      }),
      body: FutureBuilder<void>(
        future: initControlFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(cameraCtrl);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
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
    );
  }
}
