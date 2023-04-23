import 'package:flutter/material.dart';
import 'package:mi_fik/Components/Skeletons/content_1.dart';
import 'package:mi_fik/Modules/Helpers/widget.dart';
import 'package:mi_fik/Modules/Models/Contents/Content.dart';
import 'package:mi_fik/Modules/Services/Queries/ContentQueries.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/SubMenus/DetailPage/index.dart';

import 'package:mi_fik/main.dart';

class GetContent extends StatefulWidget {
  const GetContent({Key key}) : super(key: key);

  @override
  _GetContent createState() => _GetContent();
}

class _GetContent extends State<GetContent> with TickerProviderStateMixin {
  ContentQueriesService apiService;

  @override
  void initState() {
    super.initState();
    apiService = ContentQueriesService();
  }

  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    //double fullWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      maintainBottomViewPadding: false,
      child: FutureBuilder(
        future: apiService.getAllContent(
            "all", sortingHomepageContent, "all", " ", 1),
        builder:
            (BuildContext context, AsyncSnapshot<List<ContentModel>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  "Something wrong with message: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<ContentModel> contents = snapshot.data;
            return _buildListView(contents);
          } else {
            return const ContentSkeleton1();
          }
        },
      ),
    );
  }

  Widget _buildListView(List<ContentModel> contents) {
    //double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    Widget getSortingButton(active) {
      if (active == "DESC") {
        return TextButton(
          style: TextButton.styleFrom(
            backgroundColor: primaryColor,
            shape: const CircleBorder(),
          ),
          child: Icon(
            Icons.arrow_downward_rounded,
            color: whitebg,
          ),
          onPressed: () {
            setState(() {
              sortingHomepageContent = "ASC";
            });
          },
        );
      } else if (active == "ASC") {
        return TextButton(
          style: TextButton.styleFrom(
            backgroundColor: primaryColor,
            shape: const CircleBorder(),
          ),
          child: Icon(
            Icons.arrow_upward_rounded,
            color: whitebg,
          ),
          onPressed: () {
            setState(() {
              sortingHomepageContent = "DESC";
            });
          },
        );
      }
    }

    return Column(children: [
      Container(
        transform: Matrix4.translationValues(0, -10, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text("What's New ?",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: textLG,
                      fontWeight: FontWeight.w500)),
            ),
            const Spacer(),
            getSortingButton(sortingHomepageContent),
          ],
        ),
      ),
      Column(
          children: contents.map((content) {
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

                  // Open content w/ full container
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                DetailPage(passSlug: content.slugName)),
                      );

                      passSlugContent = content.slugName;
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
                                  image: getImageHeader(content.contentImage),
                                  colorFilter: ColorFilter.mode(
                                      Colors.black.withOpacity(0.5),
                                      BlendMode.darken),
                                ),
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                              ),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    getViewWidget(content.totalViews),
                                    getPeriodDateWidget(
                                        content.dateStart, content.dateEnd),
                                    const Spacer(),
                                    getUploadDateWidget(
                                        DateTime.parse(content.createdAt))
                                  ]),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          width: iconLG,
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              child: Image.network(
                                                  "https://sci.telkomuniversity.ac.id/wp-content/uploads/2022/02/13.jpg")), //For now.
                                        ),
                                        SizedBox(
                                            width: fullWidth * 0.6,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(content.contentTitle,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: blackbg,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: textMD - 1)),
                                                Text("username",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: greybg,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: textSM - 1)),
                                              ],
                                            ))
                                      ],
                                    ),
                                    getDescHeaderWidget(content.contentDesc)
                                  ]),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: Wrap(
                                  runSpacing: -5,
                                  spacing: 5,
                                  children: [
                                    getContentLoc(content.contentLoc),
                                    getTotalTag(content.contentTag)
                                  ]),
                            ),

                            //Open content w/ button.
                            Container(
                                transform:
                                    Matrix4.translationValues(0.0, 5.0, 0.0),
                                padding: EdgeInsets.zero,
                                width: fullWidth,
                                height: 35,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DetailPage(
                                              passSlug: content.slugName)),
                                    );

                                    passSlugContent = content.slugName;
                                  },
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10)),
                                    )),
                                    backgroundColor:
                                        MaterialStatePropertyAll<Color>(
                                            primaryColor),
                                  ),
                                  child: const Text('Detail'),
                                )),
                          ],
                        )),
                  )
                ],
              ),
            ));
      }).toList())
    ]);
  }
}
