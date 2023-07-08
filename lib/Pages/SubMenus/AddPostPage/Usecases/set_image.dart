import 'package:flutter/material.dart';
import 'package:full_screen_menu/full_screen_menu.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Modules/Firebases/Storages/Content/add_image.dart';
import 'package:mi_fik/Modules/Firebases/Storages/Content/remove_image.dart';
import 'package:mi_fik/Modules/Helpers/widget.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class SetImageContent extends StatefulWidget {
  const SetImageContent({Key key}) : super(key: key);

  @override
  State<SetImageContent> createState() => _SetImageContentState();
}

class _SetImageContentState extends State<SetImageContent> {
  PostImageContent fireServicePost;
  DeleteImageContent fireServiceDelete;
  XFile file;

  @override
  void initState() {
    super.initState();
    fireServicePost = PostImageContent();
    fireServiceDelete = DeleteImageContent();
  }

  Future<XFile> getImage() async {
    return await ImagePicker().pickImage(source: ImageSource.gallery);
  }

  Future<XFile> getCamera() async {
    return await ImagePicker().pickImage(source: ImageSource.camera);
  }

  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;
    bool isLoading;

    Widget getResetImageProfile(String exist) {
      if (exist != null && exist != "null") {
        return FSMenuItem(
            icon: Icon(Icons.refresh, color: whiteColor),
            text: Text('Reset', style: TextStyle(fontSize: textMD)),
            gradient: redGradient,
            onTap: () async {
              await fireServiceDelete
                  .deleteImageContent(contentAttImage)
                  .then((value) {
                if (value == true) {
                  contentAttImage = null;

                  FullScreenMenu.hide();
                  setState(() {});
                } else {
                  FullScreenMenu.hide();
                  showDialog<String>(
                      context: context,
                      builder: (BuildContext context) =>
                          const FailedDialog(text: "Failed to reset image"));
                }
              });
            });
      } else {
        return const SizedBox();
      }
    }

    return Stack(
      children: [
        GestureDetector(
          onTap: () {},
          child: Container(
            height: fullHeight * 0.25,
            transform: Matrix4.translationValues(0.0, 15, 0.0),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: getImageHeader(contentAttImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Positioned(
            bottom: 10,
            right: 20,
            child: InkWell(
                onTap: () {
                  FullScreenMenu.show(
                    context,
                    items: [
                      FSMenuItem(
                          icon: Icon(Icons.camera, color: whiteColor),
                          text: Text('Camera'.tr,
                              style: TextStyle(fontSize: textMD)),
                          gradient: orangeGradient,
                          onTap: () async {
                            var file = await getCamera();

                            if (file != null) {
                              await fireServicePost
                                  .sendImageContent(file, "content_image")
                                  .then((value) {
                                contentAttImage = value;
                              });
                              FullScreenMenu.hide();
                              setState(() {});
                            }
                          }),
                      FSMenuItem(
                        icon: Icon(Icons.folder, color: whiteColor),
                        gradient: orangeGradient,
                        text: Text('File Picker'.tr,
                            style: TextStyle(fontSize: textMD)),
                        onTap: () async {
                          var file = await getImage();

                          if (file != null) {
                            await fireServicePost
                                .sendImageContent(file, "content_image")
                                .then((value) {
                              contentAttImage = value;
                            });
                            FullScreenMenu.hide();
                            setState(() {});
                          }
                        },
                      ),
                      getResetImageProfile(contentAttImage)
                    ],
                  );
                },
                child: Container(
                    padding: EdgeInsets.all(spaceSM * 0.8),
                    decoration: BoxDecoration(
                        border: Border.all(width: 3, color: whiteColor),
                        color: infoBG,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(25))),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      child: Image.asset('assets/icon/camera.png',
                          width: fullWidth * 0.085),
                    ))))
      ],
    );
  }
}
