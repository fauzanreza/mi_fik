import 'package:flutter/material.dart';
import 'package:full_screen_menu/full_screen_menu.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Components/Typography/title.dart';
import 'package:mi_fik/Modules/Firebases/Storages/User/add_image.dart';
import 'package:mi_fik/Modules/Firebases/Storages/User/remove_image.dart';
import 'package:mi_fik/Modules/Helpers/widget.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetProfileImage extends StatefulWidget {
  @override
  _SetProfileImage createState() => _SetProfileImage();
}

class _SetProfileImage extends State<SetProfileImage> {
  PostImage fireServicePost;
  DeleteImage fireServiceDelete;
  XFile file;

  @override
  void initState() {
    super.initState();
    fireServicePost = PostImage();
    fireServiceDelete = DeleteImage();
  }

  Future<XFile> getImage() async {
    return await ImagePicker().pickImage(source: ImageSource.gallery);
  }

  @override
  Widget build(BuildContext context) {
    Future<UserProfileLeftBar> getToken() async {
      final prefs = await SharedPreferences.getInstance();
      final image = prefs.getString('image_key');
      return UserProfileLeftBar(image: image);
    }

    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return FutureBuilder<UserProfileLeftBar>(
        future: getToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            String image = snapshot.data.image;

            Widget getResetImageProfile(String exist) {
              if (exist != null && exist != "null") {
                return FSMenuItem(
                    icon: Icon(Icons.refresh, color: whitebg),
                    text: Text('Reset', style: TextStyle(fontSize: textMD)),
                    gradient: redGradient,
                    onTap: () async {
                      await fireServiceDelete.deleteImageUser().then((value) {
                        if (value == true) {
                          FullScreenMenu.hide();
                          setState(() {
                            uploadedImage = null;
                          });
                          Get.snackbar(
                              "Success", "Uploaded Image has been removed",
                              backgroundColor: whitebg);
                        } else {
                          FullScreenMenu.hide();
                          showDialog<String>(
                              context: context,
                              builder: (BuildContext context) =>
                                  FailedDialog(text: "Failed to reset image"));
                        }
                      });
                    });
              } else {
                return const SizedBox();
              }
            }

            return ListView(
              children: [
                Container(
                  padding: EdgeInsets.all(paddingMD),
                  margin: EdgeInsets.fromLTRB(
                      paddingMD, paddingLg, paddingMD, paddingMD),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: whitebg),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: getTitleLarge("Profile Picture", primaryColor),
                        ),
                        Stack(
                          children: [
                            Container(
                              height: 200,
                              width: 200,
                              margin: EdgeInsets.symmetric(vertical: paddingLg),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: getImageUser(uploadedImage),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                                bottom: fullHeight * 0.05,
                                right: fullWidth * 0.005,
                                child: InkWell(
                                    onTap: () {
                                      FullScreenMenu.show(
                                        context,
                                        items: [
                                          FSMenuItem(
                                              icon: Icon(Icons.camera,
                                                  color: whitebg),
                                              text: Text('Camera'.tr,
                                                  style: TextStyle(
                                                      fontSize: textMD)),
                                              gradient: orangeGradient,
                                              onTap: () {}),
                                          FSMenuItem(
                                            icon: Icon(Icons.folder,
                                                color: whitebg),
                                            gradient: orangeGradient,
                                            text: Text('File Picker'.tr,
                                                style: TextStyle(
                                                    fontSize: textMD)),
                                            onTap: () async {
                                              var file = await getImage();

                                              if (file != null) {
                                                await fireServicePost
                                                    .sendImageUser(file)
                                                    .then((value) {
                                                  setState(() {
                                                    uploadedImage = value;
                                                  });
                                                  FullScreenMenu.hide();
                                                });
                                              }
                                            },
                                          ),
                                          getResetImageProfile(image)
                                        ],
                                      );
                                    },
                                    child: Container(
                                        padding:
                                            EdgeInsets.all(paddingXSM * 0.8),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 3, color: whitebg),
                                            color: infoColor,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(25))),
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(12)),
                                          child: Image.asset(
                                              'assets/icon/camera.png',
                                              width: fullWidth * 0.085),
                                        )))),
                          ],
                        )
                      ]),
                )
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
