import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_menu/full_screen_menu.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mi_fik/Components/Cameras/captures.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Components/Dialogs/loading_dialog.dart';
import 'package:mi_fik/Components/Typography/title.dart';
import 'package:mi_fik/Modules/APIs/UserApi/Models/commands.dart';
import 'package:mi_fik/Modules/APIs/UserApi/Services/commands.dart';
import 'package:mi_fik/Modules/Firebases/Storages/User/add_image.dart';
import 'package:mi_fik/Modules/Firebases/Storages/User/remove_image.dart';
import 'package:mi_fik/Modules/Helpers/info.dart';
import 'package:mi_fik/Modules/Helpers/widget.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetProfileImage extends StatefulWidget {
  const SetProfileImage({Key key}) : super(key: key);

  @override
  StateSetProfileImage createState() => StateSetProfileImage();
}

class StateSetProfileImage extends State<SetProfileImage> {
  PostImage fireServicePost;
  DeleteImage fireServiceDelete;
  UserCommandsService commandService;

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
                    icon: Icon(Icons.refresh, color: whiteColor),
                    text: Text('Reset', style: TextStyle(fontSize: textXMD)),
                    gradient: redGradient,
                    onTap: () async {
                      FullScreenMenu.hide();

                      await fireServiceDelete.deleteImageUser().then((value) {
                        if (value == true) {
                          EditUserImageModel data =
                              EditUserImageModel(imageUrl: null);

                          commandService.putProfileImage(data).then((response) {
                            setState(() => {});
                            var status = response[0]['message'];
                            var body = response[0]['body'];

                            if (status == "success") {
                              showDialog<String>(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) =>
                                      const LoadingDialog(
                                          url: "assets/json/remove-file.json",
                                          destination: null));
                              setState(() {
                                uploadedImageRegis = null;
                              });
                            } else {
                              showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      FailedDialog(text: body));
                            }
                          });
                        } else {
                          showDialog<String>(
                              context: context,
                              builder: (BuildContext context) =>
                                  const FailedDialog(
                                      text: "Failed to reset image"));
                        }
                      });
                    });
              } else {
                return const SizedBox();
              }
            }

            return ListView(
                padding: EdgeInsets.fromLTRB(
                    spaceLG, spaceJumbo + spaceMD, spaceLG, spaceLG),
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: getTitleLarge("Profile Picture", primaryColor),
                  ),
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 200,
                          width: 200,
                          margin: EdgeInsets.symmetric(vertical: spaceJumbo),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.circular(roundedCircle)),
                            image: DecorationImage(
                              image: getImageUser(uploadedImageRegis),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      WillPopScope(
                          onWillPop: () {
                            FullScreenMenu.hide();
                          },
                          child: Positioned(
                              top: fullHeight * 0.225,
                              right: fullWidth * 0.15,
                              child: InkWell(
                                  onTap: () {
                                    FullScreenMenu.show(context,
                                        items: [
                                          FSMenuItem(
                                              icon: Icon(Icons.camera,
                                                  color: whiteColor),
                                              text: Text('Camera'.tr,
                                                  style: TextStyle(
                                                      fontSize: textXMD)),
                                              gradient: orangeGradient,
                                              onTap: () async {
                                                WidgetsFlutterBinding
                                                    .ensureInitialized();
                                                final cameras =
                                                    await availableCameras();
                                                FullScreenMenu.hide();
                                                Get.to(() => CameraPage(
                                                      camera: cameras.first,
                                                      from: "register",
                                                    ));
                                              }),
                                          FSMenuItem(
                                            icon: Icon(Icons.folder,
                                                color: whiteColor),
                                            gradient: orangeGradient,
                                            text: Text('File Picker'.tr,
                                                style: TextStyle(
                                                    fontSize: textXMD)),
                                            onTap: () async {
                                              var file = await getImage();

                                              if (file != null) {
                                                FullScreenMenu.hide();
                                                await fireServicePost
                                                    .sendImageUser(file)
                                                    .then((value) {
                                                  EditUserImageModel data =
                                                      EditUserImageModel(
                                                          imageUrl: value);

                                                  commandService
                                                      .putProfileImage(data)
                                                      .then((response) {
                                                    setState(() => {});
                                                    var status =
                                                        response[0]['message'];
                                                    var body =
                                                        response[0]['body'];

                                                    if (status == "success") {
                                                      showDialog<String>(
                                                          context: context,
                                                          barrierDismissible:
                                                              false,
                                                          builder: (BuildContext
                                                                  context) =>
                                                              const LoadingDialog(
                                                                  url:
                                                                      "assets/json/loading-att.json",
                                                                  destination:
                                                                      null));
                                                      setState(() {
                                                        uploadedImageRegis =
                                                            value;
                                                      });
                                                    } else {
                                                      FullScreenMenu.hide();
                                                      showDialog<String>(
                                                          context: context,
                                                          builder: (BuildContext
                                                                  context) =>
                                                              FailedDialog(
                                                                  text: body));
                                                    }
                                                  });
                                                });
                                              }
                                            },
                                          ),
                                          getResetImageProfile(image)
                                        ],
                                        backgroundColor: primaryLightBG);
                                  },
                                  child: Container(
                                      padding: EdgeInsets.all(spaceSM * 0.8),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 3, color: whiteColor),
                                          color: infoBG,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(25))),
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(12)),
                                        child: Image.asset(
                                            'assets/icon/camera.png',
                                            width: fullWidth * 0.085),
                                      ))))),
                    ],
                  ),
                  Container(
                      padding: EdgeInsets.fromLTRB(0, spaceLG, 0, 0),
                      child: const GetInfoBox(
                        page: "register",
                        location: "add_profile_pic",
                      )),
                ]);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
