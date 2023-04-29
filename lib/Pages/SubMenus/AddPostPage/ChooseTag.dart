import 'package:flutter/material.dart';
import 'package:mi_fik/Components/Forms/tag_picker.dart';
import 'package:mi_fik/Modules/Models/Tags/Tag.dart';
import 'package:mi_fik/Components/Skeletons/tag_1.dart';
import 'package:mi_fik/Modules/Services/Queries/TagQueries.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class ChooseTag extends StatefulWidget {
  const ChooseTag({Key key}) : super(key: key);

  @override
  _ChooseTag createState() => _ChooseTag();
}

class _ChooseTag extends State<ChooseTag> {
  TagService apiService;
  int pageTag = 1;

  @override
  void initState() {
    super.initState();
    apiService = TagService();
  }

  void _updateTags() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      maintainBottomViewPadding: false,
      child: FutureBuilder(
        future: apiService.getAllTag(pageTag),
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

  Widget _buildListView(List<TagModel> tags) {
    //double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    Widget getControlButton(type) {
      if (type == "more") {
        return Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(right: 15),
            child: TextButton.icon(
              onPressed: () {
                setState(() {
                  pageTag++;
                });
              },
              icon: Icon(Icons.navigate_next, color: primaryColor),
              label: Text(
                "More",
                style: TextStyle(color: primaryColor),
              ),
            ));
      } else if (type == "previous" && pageTag > 1) {
        return Container(
            alignment: Alignment.center,
            child: TextButton.icon(
              onPressed: () {
                setState(() {
                  pageTag--;
                });
              },
              icon: Icon(Icons.navigate_before, color: primaryColor),
              label: Text(
                "Previous",
                style: TextStyle(color: primaryColor),
              ),
            ));
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
              var contain = selectedTag
                  .where((item) => item['slug_name'] == tag.slugName);
              if (contain.isEmpty || selectedTag.isEmpty) {
                return ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      selectedTag.add({
                        "slug_name": tag.slugName,
                        "tag_name": tag.slugName
                      });
                    });
                  },
                  icon: Icon(
                    Icons.circle,
                    size: textSM,
                    color: Colors.green,
                  ),
                  label: Text(tag.tagName, style: TextStyle(fontSize: textXSM)),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(roundedLG2),
                    )),
                    backgroundColor:
                        MaterialStatePropertyAll<Color>(primaryColor),
                  ),
                );
              } else {
                return const SizedBox();
              }
            }).toList(),
          ),
          Row(
            children: [
              getControlButton("previous"),
              const Spacer(),
              getControlButton("more"),
            ],
          ),
          TagSelectedArea(tag: selectedTag, type: "tag", action: _updateTags)
        ]);
  }
}
