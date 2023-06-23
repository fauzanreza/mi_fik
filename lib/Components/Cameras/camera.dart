import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Bars/bottom_bar.dart';
import 'package:mi_fik/Components/Bars/top_bar.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Modules/APIs/UserApi/Models/commands.dart';
import 'package:mi_fik/Modules/APIs/UserApi/Services/commands.dart';
import 'package:mi_fik/Modules/Firebases/Storages/User/add_image.dart';
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
        Get.offAll(() => const ProfilePage());
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

class ShowImage extends StatefulWidget {
  const ShowImage({Key key, this.path, this.from}) : super(key: key);
  final String path;
  final from;

  @override
  State<ShowImage> createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {
  UserCommandsService commandService;
  PostImage fireServicePost;
  File imageFile;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    commandService = UserCommandsService();
    fireServicePost = PostImage();
    imageFile = File(widget.path);
  }

  Future<void> uploadImage() async {
    try {
      setState(() {
        isLoading = true;
      });

      final imageUrl = await fireServicePost.sendImageUser(imageFile);

      final data = EditUserImageModel(imageUrl: imageUrl);
      final response = await commandService.putProfileImage(data);

      setState(() {
        isLoading = false;
      });

      final status = response[0]['message'];
      final body = response[0]['body'];

      if (status == "success") {
        Get.to(() => const ProfilePage());
      } else {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => FailedDialog(text: body),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      Get.snackbar(
        "Error".tr,
        "Failed to upload image".tr,
        backgroundColor: primaryColor,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppbar("Preview Image".tr, () {
        Get.to(() => const BottomBar());
      }),
      body: Center(
        child: Image.file(imageFile),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: successbg,
        onPressed: isLoading ? null : uploadImage, // Disable button if loading
        child: const Icon(Icons.save),
      ),
    );
  }
}
