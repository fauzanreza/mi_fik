import 'package:flutter/material.dart';
import 'package:full_screen_menu/full_screen_menu.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mi_fik/Components/Bars/bottom_bar.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Modules/APIs/UserApi/Models/commands.dart';
import 'package:mi_fik/Modules/APIs/UserApi/Services/commands.dart';
import 'package:mi_fik/Modules/Firebases/Storages/User/add_image.dart';
import 'package:mi_fik/Modules/Firebases/Storages/User/remove_image.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/SubMenus/ProfilePage/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditImage extends StatefulWidget {
  const EditImage({Key key}) : super(key: key);

  @override
  State<EditImage> createState() => _EditImageState();
}

class _EditImageState extends State<EditImage> {
  UserCommandsService commandService;
  PostImage fireServicePost;
  DeleteImage fireServiceDelete;
  XFile file;

  @override
  void initState() {
    super.initState();
    commandService = UserCommandsService();
    fireServicePost = PostImage();
    fireServiceDelete = DeleteImage();
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
                    onTap: () async {
                      await fireServiceDelete.deleteImageUser().then((value) {
                        if (value == true) {
                          EditUserImageModel data =
                              EditUserImageModel(imageUrl: null);

                          commandService.putProfileImage(data).then((response) {
                            setState(() => isLoading = false);
                            var status = response[0]['message'];
                            var body = response[0]['body'];

                            if (status == "success") {
                              FullScreenMenu.hide();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const BottomBar()),
                              );
                            } else {
                              FullScreenMenu.hide();
                              showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      FailedDialog(text: body));
                            }
                          });
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

            return Positioned(
                top: 110,
                left: 120,
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
                                    .sendImageUser(file)
                                    .then((value) {
                                  EditUserImageModel data =
                                      EditUserImageModel(imageUrl: value);

                                  commandService
                                      .putProfileImage(data)
                                      .then((response) {
                                    setState(() => isLoading = false);
                                    var status = response[0]['message'];
                                    var body = response[0]['body'];

                                    if (status == "success") {
                                      FullScreenMenu.hide();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ProfilePage()),
                                      );
                                    } else {
                                      FullScreenMenu.hide();
                                      showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              FailedDialog(text: body));
                                    }
                                  });
                                });
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
