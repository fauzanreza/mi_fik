import 'package:flutter/material.dart';
import 'package:full_screen_menu/full_screen_menu.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mi_fik/Modules/Firebases/Storages/Content/add_image.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/SubMenus/AddPostPage/Usecases/get_attachment.dart';
import 'package:provider/provider.dart';
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

  Future<XFile> getVideo() async {
    return await ImagePicker().pickVideo(source: ImageSource.gallery);
  }

  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;
    bool isLoading;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        alignment: Alignment.centerLeft,
        child: SizedBox(
          width: 180,
          height: 40,
          child: TextButton.icon(
            onPressed: () async {
              FullScreenMenu.show(
                context,
                items: [
                  FSMenuItem(
                      icon: Icon(Icons.camera, color: whitebg),
                      text: Text('Camera', style: TextStyle(fontSize: textMD)),
                      gradient: orangeGradient,
                      onTap: () {}),
                  FSMenuItem(
                      icon: Icon(Icons.link, color: whitebg),
                      text: Text('URL', style: TextStyle(fontSize: textMD)),
                      gradient: orangeGradient,
                      onTap: () {
                        var type = "attachment_url";
                        listAttachment.add({
                          "id": Uuid().v4().substring(0, 8),
                          "attach_type": type,
                          "attach_name": null,
                          "attach_url": null
                        });
                        FullScreenMenu.hide();
                        setState(() {});
                      }),
                  FSMenuItem(
                      icon: Icon(Icons.document_scanner, color: whitebg),
                      text: Text('Doc', style: TextStyle(fontSize: textMD)),
                      gradient: orangeGradient,
                      onTap: () {}),
                  FSMenuItem(
                    icon: Icon(Icons.image_outlined, color: whitebg),
                    gradient: orangeGradient,
                    text: Text('Image Picker',
                        style: TextStyle(fontSize: textMD)),
                    onTap: () async {
                      var file = await getImage();
                      var type = "attachment_image";

                      if (file != null) {
                        await fireServicePost
                            .sendImageContent(file, type)
                            .then((value) {
                          listAttachment.add({
                            "id": Uuid().v4().substring(0, 8),
                            "attach_type": type,
                            "attach_name": null,
                            "attach_url": value
                          });
                        });
                        FullScreenMenu.hide();
                        setState(() {});
                        print(listAttachment);
                      }
                    },
                  ),
                  FSMenuItem(
                    icon: Icon(Icons.ondemand_video, color: whitebg),
                    gradient: orangeGradient,
                    text: Text('Video Picker',
                        style: TextStyle(fontSize: textMD)),
                    onTap: () async {
                      var file = await getVideo();
                      var type = "attachment_video";

                      if (file != null) {
                        await fireServicePost
                            .sendImageContent(file, type)
                            .then((value) {
                          listAttachment.add({
                            "id": Uuid().v4().substring(0, 8),
                            "attach_type": type,
                            "attach_name": null,
                            "attach_url": value
                          });
                        });
                        FullScreenMenu.hide();
                        setState(() {});
                        print(listAttachment);
                      }
                    },
                  ),
                ],
              );
            },
            icon: Icon(
              Icons.attach_file,
              color: semiblackbg,
            ), //icon data for elevated button
            label: Text("Insert Attachment",
                style: TextStyle(
                    fontSize: textMD,
                    color: semiblackbg,
                    fontWeight: FontWeight.w400)),
            //label text
          ),
        ),
      ),
      GetFileAttachment()
    ]);
  }
}
