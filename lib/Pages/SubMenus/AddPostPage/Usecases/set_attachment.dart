import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_menu/full_screen_menu.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Modules/Firebases/Storages/Content/add_image.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/SubMenus/AddPostPage/Usecases/get_attachment.dart';
import 'package:uuid/uuid.dart';

class SetFileAttachment extends StatefulWidget {
  const SetFileAttachment({Key key}) : super(key: key);

  @override
  State<SetFileAttachment> createState() => _SetFileAttachmentState();
}

class _SetFileAttachmentState extends State<SetFileAttachment> {
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

  Future<XFile> getCamera() async {
    return await ImagePicker().pickImage(source: ImageSource.camera);
  }

  Future<XFile> getVideo() async {
    return await ImagePicker().pickVideo(source: ImageSource.gallery);
  }

  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    //double fullWidth = MediaQuery.of(context).size.width;
    bool isLoading;

    uploadFile(var bytes, var file, String type, int max) async {
      if ((bytes.lengthInBytes / (1024 * 1024)) <= max) {
        await fireServicePost.sendImageContent(file, type).then((value) {
          listAttachment.add({
            "id": const Uuid().v4().substring(0, 8),
            "attach_type": type,
            "attach_name": null,
            "attach_url": value
          });
        });
        FullScreenMenu.hide();
        setState(() {});
      } else {
        FullScreenMenu.hide();
        showDialog<String>(
            context: context,
            builder: (BuildContext context) => FailedDialog(
                text: "Upload failed, the file size must below $maxImage mb",
                type: "openevent"));
      }
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        alignment: Alignment.centerLeft,
        child: SizedBox(
          height: 40,
          child: TextButton.icon(
            onPressed: () async {
              FullScreenMenu.show(
                context,
                items: [
                  FSMenuItem(
                      icon: Icon(Icons.camera, color: whiteColor),
                      text: Text('Camera'.tr,
                          style: TextStyle(fontSize: textXMD)),
                      gradient: orangeGradient,
                      onTap: () async {
                        var file = await getCamera();
                        var type = "attachment_image";

                        if (file != null) {
                          final bytes = await file.readAsBytes();

                          uploadFile(bytes, file, type, maxImage);
                        }
                      }),
                  FSMenuItem(
                      icon: Icon(Icons.link, color: whiteColor),
                      text: Text('URL', style: TextStyle(fontSize: textXMD)),
                      gradient: orangeGradient,
                      onTap: () {
                        var type = "attachment_url";
                        listAttachment.add({
                          "id": const Uuid().v4().substring(0, 8),
                          "attach_type": type,
                          "attach_name": null,
                          "attach_url": null
                        });
                        FullScreenMenu.hide();
                        setState(() {});
                      }),
                  FSMenuItem(
                      icon: Icon(Icons.document_scanner, color: whiteColor),
                      text: Text('Pdf', style: TextStyle(fontSize: textXMD)),
                      gradient: orangeGradient,
                      onTap: () async {
                        FilePickerResult result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['pdf'],
                        );
                        var type = "attachment_doc";
                        File file = File(result.files.single.path);

                        if (file != null) {
                          final bytes = await file.readAsBytes();

                          uploadFile(bytes, file, type, maxDoc);
                        }
                      }),
                  FSMenuItem(
                    icon: Icon(Icons.image_outlined, color: whiteColor),
                    gradient: orangeGradient,
                    text: Text('Image Picker'.tr,
                        style: TextStyle(fontSize: textXMD)),
                    onTap: () async {
                      var file = await getImage();
                      var type = "attachment_image";

                      if (file != null) {
                        final bytes = await file.readAsBytes();

                        uploadFile(bytes, file, type, maxImage);
                      }
                    },
                  ),
                  FSMenuItem(
                    icon: Icon(Icons.ondemand_video, color: whiteColor),
                    gradient: orangeGradient,
                    text: Text('Video Picker'.tr,
                        style: TextStyle(fontSize: textXMD)),
                    onTap: () async {
                      var file = await getVideo();
                      var type = "attachment_video";

                      if (file != null) {
                        final bytes = await file.readAsBytes();

                        uploadFile(bytes, file, type, maxVideo);
                      }
                    },
                  ),
                ],
              );
            },
            icon: Icon(
              Icons.attach_file,
              color: semidarkColor,
            ),
            label: Text("Insert Attachment",
                style: TextStyle(
                    fontSize: textXMD,
                    color: semidarkColor,
                    fontWeight: FontWeight.w400)),
          ),
        ),
      ),
      // Dont use const in this class
      // ignore: prefer_const_constructors
      GetFileAttachment()
    ]);
  }
}
