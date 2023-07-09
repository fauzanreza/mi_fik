import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_menu/full_screen_menu.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Bars/top_bar.dart';
import 'package:mi_fik/Components/Cameras/captures.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Modules/APIs/UserApi/Models/commands.dart';
import 'package:mi_fik/Modules/APIs/UserApi/Services/commands.dart';
import 'package:mi_fik/Modules/Firebases/Storages/User/add_image.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/Landings/RegisterPage/index.dart';
import 'package:mi_fik/Pages/SubMenus/AddPostPage/index.dart';
import 'package:mi_fik/Pages/SubMenus/ProfilePage/index.dart';

class ShowImage extends StatefulWidget {
  const ShowImage({Key key, this.path, this.from, this.loadingCtrl})
      : super(key: key);
  final String path;
  final String from;
  final AnimationController loadingCtrl;

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
      var response;

      if (widget.from == "profile") {
        if (imageFile != null) {
          final imageUrl = await fireServicePost.sendImageUser(imageFile);

          final data = EditUserImageModel(imageUrl: imageUrl);
          response = await commandService.putProfileImage(data);
        } else {
          Get.snackbar("Error".tr, "Failed to upload, file doesnt exist".tr,
              backgroundColor: whiteColor);
          Get.offAll(() => const ProfilePage());
        }
      } else if (widget.from == "addpost") {
        //
      } else if (widget.from == "register") {
        if (imageFile != null) {
          await fireServicePost.sendImageUser(imageFile).then((value) {
            EditUserImageModel data = EditUserImageModel(imageUrl: value);

            commandService.putProfileImage(data).then((response) {
              setState(() => isLoading = false);
              var status = response[0]['message'];
              var body = response[0]['body'];

              if (status == "success") {
                setState(() {
                  uploadedImageRegis = value;
                });
                FullScreenMenu.hide();
              } else {
                FullScreenMenu.hide();
                Get.dialog(FailedDialog(text: body));
              }
            });
          });
        } else {
          Get.snackbar("Error".tr, "Failed to upload, file doesnt exist".tr,
              backgroundColor: whiteColor);
          Get.offAll(() => const RegisterPage());
        }
      }

      setState(() {
        isLoading = false;
      });

      final status = response[0]['message'];
      final body = response[0]['body'];

      if (status == "success") {
        if (widget.from == "profile") {
          widget.loadingCtrl.reset();
          Get.offAll(() => const ProfilePage());
        } else if (widget.from == "addpost") {
          widget.loadingCtrl.reset();
          Get.offAll(() => const AddPost());
        } else if (widget.from == "register") {
          widget.loadingCtrl.reset();
          Get.offAll(() => const RegisterPage());
        }
      } else {
        Get.dialog(FailedDialog(text: body));
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
      appBar: getAppbar("Preview Image".tr, () async {
        WidgetsFlutterBinding.ensureInitialized();
        final cameras = await availableCameras();
        Get.to(() => CameraPage(
              camera: cameras.first,
              from: widget.from,
            ));
      }),
      body: Center(
        child: Image.file(imageFile),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: successBG,
        onPressed: isLoading ? null : uploadImage, // Disable button if loading
        child: const Icon(Icons.save),
      ),
    );
  }
}
