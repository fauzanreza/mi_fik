import 'package:flutter/material.dart';
import 'package:full_screen_menu/full_screen_menu.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mi_fik/Modules/Firebases/Storages/Content/add_image.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
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

  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;
    bool isLoading;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
          margin: const EdgeInsets.only(left: 10),
          child: Text('ex : URL, Video, Image, Doc',
              style: TextStyle(fontSize: textSM))),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.fromLTRB(20, 5, 0, 0),
        child: SizedBox(
          width: 180,
          height: 40,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              foregroundColor: primaryColor,
              backgroundColor: whitebg,
              side: BorderSide(
                width: 1.0,
                color: primaryColor,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
            ),
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
                    icon: Icon(Icons.folder, color: whitebg),
                    gradient: orangeGradient,
                    text:
                        Text('File Picker', style: TextStyle(fontSize: textMD)),
                    onTap: () async {
                      var file = await getImage();

                      if (file != null) {
                        await fireServicePost
                            .sendImageContent(file, "attachment_image")
                            .then((value) {
                          listAttachment.add({
                            "id": Uuid().v4().substring(0, 8),
                            "attach_type": "attachment_image",
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
            icon: const Icon(Icons.attach_file), //icon data for elevated button
            label: const Text("Insert Attachment"),
            //label text
          ),
        ),
      ),
    ]);
  }
}
