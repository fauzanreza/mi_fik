import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mi_fik/AddPost/ChooseTag.dart';
import 'package:mi_fik/DB/Model/Content.dart';
import 'package:mi_fik/DB/Services/ContentServices.dart';
import 'package:mi_fik/Others/FailedDialog.dart';
import 'package:mi_fik/Others/SuccessDialog.dart';
import 'package:mi_fik/main.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class addPost extends StatefulWidget {
  const addPost({Key key}) : super(key: key);

  @override
  _addPost createState() => _addPost();
}

class _addPost extends State<addPost> {
  ContentService apiService;

  //Initial variable
  final contentTitleCtrl = TextEditingController();
  final contentDescCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    apiService = ContentService();
  }

  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;
    bool _isLoading = false;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {},
            child: Container(
              height: fullHeight * 0.275,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/content/content-2.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            transform: Matrix4.translationValues(0.0, fullHeight * 0.03, 0.0),
            child: IconButton(
              icon: Icon(Icons.arrow_back, size: iconLG),
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: fullHeight * 0.25),
            height: fullHeight * 0.8,
            width: fullWidth,
            padding: EdgeInsets.only(top: paddingMD),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(roundedLG2),
              color: Colors.white,
            ),
            child: ListView(padding: EdgeInsets.zero, children: [
              Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextFormField(
                  cursorColor: Colors.white,
                  controller: contentTitleCtrl,
                  decoration: InputDecoration(
                      hintText: 'Title',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            width: 1, color: Color(0xFFFB8C00)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            width: 1, color: Color(0xFFFB8C00)),
                      ),
                      fillColor: Colors.white,
                      filled: true),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: TextFormField(
                  cursorColor: Colors.white,
                  controller: contentDescCtrl,
                  decoration: InputDecoration(
                      hintText: 'Content',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            width: 1, color: Color(0xFFFB8C00)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            width: 1, color: Color(0xFFFB8C00)),
                      ),
                      fillColor: Colors.white,
                      filled: true),
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                child: SizedBox(
                  width: 180, // <-- Your width
                  height: 40,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: const Color(0xFFFB8C00),
                      side: const BorderSide(
                        width: 1.0,
                        color: Color(0xFFFB8C00),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                    ),
                    onPressed: () async {
                      FilePickerResult result = await FilePicker.platform
                          .pickFiles(allowMultiple: true);
                    },
                    icon: const Icon(
                        Icons.attach_file), //icon data for elevated button
                    label: const Text("Insert Attachment"),
                    //label text
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(left: paddingMD),
                  padding: EdgeInsets.only(top: paddingXSM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Choose Tags",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            color: Color(0xFFFB8C00),
                            fontWeight: FontWeight.w500,
                          )),
                      Container(
                          transform: Matrix4.translationValues(0.0, -15.0, 0.0),
                          child: ChooseTag()),
                    ],
                  )),
              Row(children: <Widget>[
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 16),
                      foregroundColor: const Color(0xFFFB8C00),
                    ), // <-- TextButton
                    onPressed: () {},
                    icon: const Icon(
                      Icons.location_pin,
                      size: 24.0,
                    ),
                    label: const Text('Set My Location'),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(30, 10, 0, 0),
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 16),
                      foregroundColor: const Color(0xFFFB8C00),
                    ), // <-- TextButton
                    onPressed: () {},
                    icon: const Icon(
                      Icons.calendar_month,
                      size: 24.0,
                    ),
                    label: const Text('Set Date'),
                  ),
                ),
              ]),
              Row(children: <Widget>[
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 16),
                        foregroundColor: primaryColor), // <-- TextButton
                    onPressed: () {},
                    icon: const Icon(
                      Icons.timer_outlined,
                      size: 24.0,
                    ),
                    label: const Text('Set Time'),
                  ),
                ),
                Row(children: <Widget>[
                  Container(
                    padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 16),
                        foregroundColor: const Color(0xFFFB8C00),
                      ),
                      onPressed: () {},
                      child: const Text('Reminder :'),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: const Color(0xFFFB8C00),
                        side: const BorderSide(
                          width: 1.0,
                          color: Color(0xFFFB8C00),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                      onPressed: () {},
                      child: const Text('1 Hour Before'),
                    ),
                  ),
                ]),
              ]),
            ]),
          ),
          Container(
              transform: Matrix4.translationValues(0.0, fullHeight * 0.94, 0.0),
              width: fullWidth,
              height: btnHeightMD,
              child: ElevatedButton(
                onPressed: () async {
                  //Validate json.
                  validateNullJSON(val) {
                    if (val.length != 0) {
                      return jsonEncode(val);
                    } else {
                      return null;
                    }
                  }

                  //Mapping.
                  ContentModel content = ContentModel(
                    contentTitle: contentTitleCtrl.text.toString(),
                    contentSubtitle: "Lorem ipsum", //For now.
                    contentDesc: contentDescCtrl.text.toString(),
                    contentTag: validateNullJSON(selectedTag),
                    contentLoc: null, //For now.
                    contentAttach: null, //For now.
                    dateStart: null, //For now.
                    dateEnd: null, //For now.
                  );

                  //Validator
                  if (content.contentTitle.isNotEmpty &&
                      content.contentDesc.isNotEmpty) {
                    apiService.addContent(content).then((isError) {
                      setState(() => _isLoading = false);
                      if (isError) {
                        Navigator.pop(context);
                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) =>
                                FailedDialog(text: "Create content failed"));
                      } else {
                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) =>
                                SuccessDialog(text: "Create content success"));
                        print("Success");
                        selectedTag.clear();
                      }
                    });
                  } else {
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => FailedDialog(
                            text:
                                "Create content failed, field can't be empty"));
                  }

                  // print(jsonEncode(selectedTag).toString());
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll<Color>(primaryColor),
                ),
                child: const Text('Save Event'),
              ))
        ],
      ),
    );
  }
}
