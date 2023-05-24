import 'package:flutter/material.dart';
import 'package:full_screen_menu/full_screen_menu.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mi_fik/Modules/Firebases/Storages/Content/add_image.dart';
import 'package:mi_fik/Modules/Firebases/Storages/User/add_image.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetImageAttachment extends StatefulWidget {
  const SetImageAttachment({Key key}) : super(key: key);

  @override
  State<SetImageAttachment> createState() => _SetImageAttachmentState();
}

class _SetImageAttachmentState extends State<SetImageAttachment> {
  PostImageContent fireServicePost;
  XFile file;

  @override
  void initState() {
    super.initState();
    fireServicePost = PostImageContent();
  }

  Future<XFile> getImage() async {
    return await ImagePicker().pickImage(source: ImageSource.gallery);
  }

  @override
  Widget build(BuildContext context) {
    double fullWidth = MediaQuery.of(context).size.width;
    bool isLoading;

    Future<UserProfileLeftBar> getToken() async {
      final prefs = await SharedPreferences.getInstance();
      final image = prefs.getString('image_key');
      return UserProfileLeftBar(image: image);
    }

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
                    onTap: () async {});
              } else {
                return const SizedBox();
              }
            }

            return Positioned(
                bottom: 10,
                right: 20,
                child: InkWell(
                    onTap: () {
                      FullScreenMenu.show(
                        context,
                        items: [
                          FSMenuItem(
                              icon: Icon(Icons.camera, color: whitebg),
                              text: Text('Camera',
                                  style: TextStyle(fontSize: textMD)),
                              gradient: orangeGradient,
                              onTap: () {}),
                          FSMenuItem(
                            icon: Icon(Icons.folder, color: whitebg),
                            gradient: orangeGradient,
                            text: Text('File Picker',
                                style: TextStyle(fontSize: textMD)),
                            onTap: () async {
                              var file = await getImage();

                              if (file != null) {
                                await fireServicePost
                                    .sendImageContent(file, "content_image")
                                    .then((value) {
                                  contentAttImage = value;
                                  print(value);
                                });
                                FullScreenMenu.hide();
                              }
                            },
                          ),
                          getResetImageProfile(image)
                        ],
                      );
                    },
                    child: Container(
                        padding: EdgeInsets.all(paddingXSM * 0.8),
                        decoration: BoxDecoration(
                            border: Border.all(width: 3, color: whitebg),
                            color: infoColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(25))),
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          child: Image.asset('assets/icon/camera.png',
                              width: fullWidth * 0.085),
                        ))));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
