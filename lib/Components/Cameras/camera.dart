import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Bars/bottom_bar.dart';
import 'package:mi_fik/Components/Bars/top_bar.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/SubMenus/ProfilePage/index.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key key, this.camera, this.from}) : super(key: key);
  final CameraDescription camera;
  final from;

  @override
  State<CameraPage> createState() => StateCameraPageState();
}

class StateCameraPageState extends State<CameraPage> {
  CameraController cameractrl;
  Future<void> initControlFuture;

  @override
  void initState() {
    super.initState();
    cameractrl = CameraController(widget.camera, ResolutionPreset.medium);
    initControlFuture = cameractrl.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppbar("Take a Picture".tr, () {
        Get.offAll(() => const ProfilePage());
      }),
      body: FutureBuilder<void>(
          future: initControlFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return CameraPreview(cameractrl);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
      floatingActionButton: FloatingActionButton(
          backgroundColor: primaryColor,
          onPressed: () async {
            try {
              final img = await cameractrl.takePicture();

              Get.offAll(() => ShowImage(
                    path: img.path,
                    from: widget.from,
                  ));
            } catch (e) {
              Get.snackbar("Error".tr, "Failed to capture image".tr,
                  backgroundColor: primaryColor);
            }
          },
          child: const Icon(Icons.camera_alt)),
    );
  }
}

class ShowImage extends StatefulWidget {
  const ShowImage({Key key, this.path, this.from}) : super(key: key);
  final String path;
  final from;

  @override
  State<ShowImage> createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: getAppbar("Preview Image".tr, () {
          Get.to(() => const BottomBar());
        }),
        body: Center(
          child: Image.file(File(widget.path)),
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: successbg,
            onPressed: () async {},
            child: const Icon(Icons.save)));
  }
}
