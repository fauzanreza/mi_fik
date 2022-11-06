import 'package:flutter/material.dart';
import 'package:mi_fik/DB/Model/Tag.dart';
import 'package:mi_fik/DB/Services/TagServices.dart';
import 'package:mi_fik/Others/skeleton/tag_1.dart';
import 'package:mi_fik/main.dart';

class ChooseTag extends StatefulWidget {
  const ChooseTag({Key key}) : super(key: key);

  @override
  _ChooseTag createState() => _ChooseTag();
}

class _ChooseTag extends State<ChooseTag> {
  TagService apiService;

  @override
  void initState() {
    super.initState();
    apiService = TagService();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      maintainBottomViewPadding: false,
      child: FutureBuilder(
        future: apiService.getAllTag(),
        builder:
            (BuildContext context, AsyncSnapshot<List<TagModel>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  "Something wrong with message: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<TagModel> tags = snapshot.data;
            return _buildListView(tags);
          } else {
            return const TagSkeleton1();
          }
        },
      ),
    );
  }

  @override
  Widget _buildListView(List<TagModel> tags) {
    int i = 0;
    int max = 10; //Maximum tag
    //double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    Widget getSelectedTag(tag) {
      if (tag.length != 0) {
        return Container(
            margin: EdgeInsets.only(top: 10, right: paddingMD),
            width: fullWidth,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(
                color: primaryColor,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Selected Tag", style: TextStyle(color: primaryColor)),
                  Wrap(
                    runSpacing: -5,
                    spacing: 5,
                    children: tag.map<Widget>((tg) {
                      return OutlinedButton.icon(
                        onPressed: () {
                          //Remove selected tag
                          setState(() {
                            selectedTag
                                .removeWhere((item) => item['id'] == tg['id']);
                          });
                        },
                        icon: Icon(
                          Icons.close,
                          color: Colors.red.withOpacity(0.7),
                        ),
                        label: Text(tg['tag_name'],
                            style: TextStyle(
                                fontSize: textXSM, color: primaryColor)),
                        style: ButtonStyle(
                          side: MaterialStateProperty.all(BorderSide(
                              color: primaryColor,
                              width: 1.5,
                              style: BorderStyle.solid)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(roundedLG2),
                          )),
                          backgroundColor:
                              MaterialStatePropertyAll<Color>(whitebg),
                        ),
                      );
                    }).toList(),
                  )
                ]));
      } else {
        return const SizedBox();
      }
    }

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Wrap(
            runSpacing: -5,
            spacing: 5,
            children: tags.map<Widget>((tag) {
              //Check if tag already selected
              var contain =
                  selectedTag.where((item) => item['id'] == int.parse(tag.id));
              if (contain.isEmpty || selectedTag.isEmpty) {
                if (i < max) {
                  i++;
                  return ElevatedButton.icon(
                    onPressed: () {
                      //Store selected tags
                      setState(() {
                        selectedTag.add(
                            {"id": int.parse(tag.id), "tag_name": tag.tagName});
                      });
                    },
                    icon: Icon(
                      Icons.circle,
                      size: textSM,
                      color: Colors.green,
                    ),
                    label:
                        Text(tag.tagName, style: TextStyle(fontSize: textXSM)),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(roundedLG2),
                      )),
                      backgroundColor:
                          MaterialStatePropertyAll<Color>(primaryColor),
                    ),
                  );
                } else if (i == max) {
                  i++;
                  return Container(
                      margin: const EdgeInsets.only(right: 5),
                      child: TextButton(
                        onPressed: () => showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            contentPadding: EdgeInsets.all(paddingMD),
                            title: Text(
                              'All Tag',
                              style: TextStyle(
                                  color: primaryColor, fontSize: textMD),
                            ),
                            content: SizedBox(
                                width: fullWidth,
                                child: Wrap(
                                    runSpacing: -5,
                                    spacing: 5,
                                    children: tags.map<Widget>((tag) {
                                      return ElevatedButton.icon(
                                        onPressed: () {
                                          // Respond to button press
                                        },
                                        icon: Icon(
                                          Icons.circle,
                                          size: textSM,
                                          color: Colors.green,
                                        ),
                                        label: Text(tag.tagName,
                                            style:
                                                TextStyle(fontSize: textXSM)),
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                roundedLG2),
                                          )),
                                          backgroundColor:
                                              MaterialStatePropertyAll<Color>(
                                                  primaryColor),
                                        ),
                                      );
                                    }).toList())),
                          ),
                        ),
                        child: Text(
                          "See ${tags.length - max} More",
                          style: TextStyle(color: primaryColor),
                        ),
                      ));
                } else {
                  return const SizedBox();
                }
              } else {
                return const SizedBox();
              }
            }).toList(),
          ),
          getSelectedTag(selectedTag)
        ]);
  }
}
