import 'package:flutter/material.dart';
import 'package:mi_fik/Modules/Helpers/converter.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class TagSelectedArea extends StatefulWidget {
  TagSelectedArea({Key key, this.tag, this.type, this.action})
      : super(key: key);
  List tag;
  String type;
  final Function action;

  @override
  StateTagSelectedArea createState() => StateTagSelectedArea();
}

class StateTagSelectedArea extends State<TagSelectedArea> {
  @override
  Widget build(BuildContext context) {
    double fullWidth = MediaQuery.of(context).size.width;

    if (widget.tag.isNotEmpty) {
      return Container(
          margin: EdgeInsets.only(top: 10, right: paddingMD),
          width: fullWidth,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(10.0),
              ),
              color: semiPrimaryBg),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Selected ${ucFirst(widget.type)}",
                    style:
                        TextStyle(color: blackbg, fontWeight: FontWeight.w500)),
                Wrap(
                  runSpacing: -5,
                  spacing: 5,
                  children: widget.tag.map<Widget>((tg) {
                    return OutlinedButton.icon(
                      onPressed: () {
                        if (widget.type == "tag") {
                          setState(() {
                            selectedTag.removeWhere(
                                (item) => item['slug_name'] == tg['slug_name']);
                          });
                          widget.action();
                        } else if (widget.type == "role") {
                          setState(() {
                            selectedRole.removeWhere(
                                (item) => item['slug_name'] == tg['slug_name']);
                          });
                          //widget.action();
                        } else if (widget.type == "filter") {
                          setState(() {
                            selectedTagFilterContent.removeWhere(
                                (item) => item['slug_name'] == tg['slug_name']);
                          });
                          // widget.action(); i dont know why tf this shit can run as the others
                        }
                      },
                      icon: Icon(
                        Icons.close,
                        color: dangerColor.withOpacity(0.7),
                      ),
                      label: Text(tg['tag_name'],
                          style:
                              TextStyle(fontSize: textSM, color: primaryColor)),
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
}
