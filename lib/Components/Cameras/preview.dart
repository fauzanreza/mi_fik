import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Bars/top_bar.dart';
import 'package:mi_fik/Components/Cameras/captures.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Components/Dialogs/loading_dialog.dart';
import 'package:mi_fik/Modules/APIs/UserApi/Models/commands.dart';
import 'package:mi_fik/Modules/APIs/UserApi/Services/commands.dart';
import 'package:mi_fik/Modules/Firebases/Storages/User/add_image.dart';
import 'package:mi_fik/Modules/Routes/collection.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class ShowImage extends StatefulWidget {
  const ShowImage({Key key, this.path, this.from}) : super(key: key);
  final String path;
  final String from;

  @override
  State<ShowImage> createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage>
    with SingleTickerProviderStateMixin {
  UserCommandsService commandService;
  PostImage fireServicePost;
  File imageFile;
  bool isLoading = false;
  AnimationController lottieController;

  @override
  void initState() {
    super.initState();
    commandService = UserCommandsService();
    fireServicePost = PostImage();
    imageFile = File(widget.path);
    lottieController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    lottieController.dispose();
    super.dispose();
  }

  Future<void> uploadImage() async {
    try {
      Get.dialog(LoadingDialog(
          url: "assets/json/loading-att.json", ctrl: lottieController));

      setState(() {
        isLoading = true;
      });
      List response;

      if (widget.from == "profile" || widget.from == "register") {
        if (imageFile != null) {
          final imageUrl = await fireServicePost.sendImageUser(imageFile);

          final data = EditUserImageModel(imageUrl: imageUrl);
          response = await commandService.putProfileImage(data);
          if (widget.from == "register") {
            setState(() {
              uploadedImageRegis = imageUrl;
            });
          }
        } else {
          Get.snackbar("Error".tr, "Failed to upload, file doesnt exist".tr,
              backgroundColor: whiteColor);
          if (widget.from == "profile") {
            Get.toNamed(CollectionRoute.profile, preventDuplicates: false);
          } else if (widget.from == "register") {
            Get.toNamed(CollectionRoute.register, preventDuplicates: false);
          }
        }
      } else if (widget.from == "addpost") {
        //
      }

      setState(() {
        isLoading = false;
      });

      final status = response[0]['message'];
      final body = response[0]['body'];

      if (status == "success") {
        if (widget.from == "profile") {
          lottieController.reset();
          Get.toNamed(CollectionRoute.profile, preventDuplicates: false);
        } else if (widget.from == "addpost") {
          lottieController.reset();
          Get.toNamed(CollectionRoute.addpost, preventDuplicates: false);
        } else if (widget.from == "register") {
          lottieController.reset();
          Get.toNamed(CollectionRoute.register, preventDuplicates: false);
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
        "Failed to upload image $e".tr,
        backgroundColor: whiteColor,
      );

      Future.delayed(const Duration(seconds: 2), () {
        if (widget.from == "profile") {
          Get.toNamed(CollectionRoute.profile, preventDuplicates: false);
        } else {
          Get.toNamed(CollectionRoute.register, preventDuplicates: false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double fullWidth = MediaQuery.of(context).size.width;
    double fullHeight = MediaQuery.of(context).size.height;

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
          child: SizedBox(
        width: fullWidth,
        height: fullHeight,
        child: Image.file(imageFile),
      )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: successBG,
        onPressed:
            isLoading == true ? null : uploadImage, // Disable button if loading
        child: const Icon(Icons.save),
      ),
    );
  }
}
