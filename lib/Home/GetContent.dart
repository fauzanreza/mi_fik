import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mi_fik/DB/Database.dart';
import 'package:mi_fik/DB/Model/Content_M.dart';
import 'package:mi_fik/Home/Detail/index.dart';
import 'package:mi_fik/main.dart';

class GetContent extends StatefulWidget {
  const GetContent({Key key}) : super(key: key);

  @override
  _GetContent createState() => _GetContent();
}

class _GetContent extends State<GetContent> with TickerProviderStateMixin {
  //Initial variable
  var db = Mysql();
  final List<ContentModel> _contentList = <ContentModel>[];

  //Controller
  Future getContent() async {
    db.getConnection().then((conn) {
      String sql = 'SELECT * FROM content ORDER BY created_at DESC';
      conn.query(sql).then((results) {
        for (var row in results) {
          setState(() {
            //Mapping
            var contentModels = ContentModel();

            contentModels.id = row['id'];
            contentModels.contentTitle = row['content_title'];
            contentModels.contentDesc = row['content_desc'].toString();
            contentModels.createdAt = row['created_at'];

            _contentList.add(contentModels);
          });
        }
      });
      conn.close();
    });
  }

  Widget getUploadDate(date) {
    //Initial variable.
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final justNowHour = DateTime(now.hour);
    final justNowMinute = DateFormat("mm").format(now);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final content = DateTime(date.year, date.month, date.day);
    final contentHour = DateTime(date.hour);
    final contentMinute = DateFormat("mm").format(date);

    var result = "";

    if (content == today) {
      if (justNowHour == contentHour) {
        int diff = int.parse((justNowMinute).toString()) -
            int.parse((contentMinute).toString());
        if (diff > 10) {
          result = "${diff} min ago";
        } else {
          result = "Just Now";
        }
      } else {
        result = "Today at ${DateFormat("HH:mm").format(date).toString()}";
      }
    } else if (content == yesterday) {
      result = "Yesterday at ${DateFormat("HH:mm").format(date).toString()}";
    } else {
      result = DateFormat("dd/MM/yy HH:mm").format(date).toString();
    }

    return Text(result,
        style: TextStyle(
          color: whitebg,
          fontWeight: FontWeight.w500,
        ));
  }

  @override
  void initState() {
    super.initState();
    getContent();
  }

  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return Column(
        children: _contentList.map((content) {
      return SizedBox(
          width: fullWidth,
          child: IntrinsicHeight(
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: fullWidth * 0.03),
                  width: 2.5,
                  color: primaryColor,
                ),

                //    CONTENT DOT????

                // Container(
                //   width: 20,
                //   margin: EdgeInsets.symmetric(
                //       horizontal: fullWidth * 0.01),
                //   transform: Matrix4.translationValues(
                //       0.0, -15.0, 0.0),
                //   decoration: BoxDecoration(
                //       color: mainbg,
                //       shape: BoxShape.circle,
                //       border: Border.all(
                //         color: primaryColor,
                //         width: 2.5,
                //       )),
                // ),

                //Open content w/ full container
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DetailPage(passIdContent: content.id)),
                    );
                  },
                  child: Container(
                      width: fullWidth * 0.82,
                      margin: EdgeInsets.only(bottom: marginMD),
                      transform: Matrix4.translationValues(40.0, 5.0, 0.0),
                      decoration: BoxDecoration(
                        color: whitebg,
                        borderRadius: BorderRadius.all(roundedMd),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 128, 128, 128)
                                .withOpacity(0.3),
                            blurRadius: 10.0,
                            spreadRadius: 0.0,
                            offset: const Offset(
                              5.0,
                              5.0,
                            ),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: 108.0,
                            width: fullWidth,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.fitWidth,
                                image: const AssetImage(
                                    'assets/content/content-2.jpg'),
                                colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(0.5),
                                    BlendMode.darken),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [getUploadDate(content.createdAt)]),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(content.contentTitle,
                                      style: TextStyle(
                                          color: blackbg,
                                          fontWeight: FontWeight.bold,
                                          fontSize: textMD)),
                                  Text(content.contentDesc,
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: blackbg, fontSize: textSM))
                                ]),
                          ),

                          //Open content w/ button.
                          Container(
                              transform:
                                  Matrix4.translationValues(0.0, 5.0, 0.0),
                              padding: EdgeInsets.zero,
                              width: fullWidth,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DetailPage(
                                            passIdContent: content.id)),
                                  );
                                },
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                                  backgroundColor:
                                      MaterialStatePropertyAll<Color>(
                                          primaryColor),
                                ),
                                child: const Text('Detail'),
                              ))
                        ],
                      )),
                )
              ],
            ),
          ));
    }).toList());
  }
}
