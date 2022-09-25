import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mi_fik/DB/Database.dart';
import 'package:mi_fik/main.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.passIdContent});
  final int passIdContent;

  @override
  _DetailPage createState() => _DetailPage();
}

class _DetailPage extends State<DetailPage> {
  //Initial variable.
  var db = Mysql();
  var content_title = "";
  var content_desc = "";
  var content_attach;
  var content_tag;
  var content_loc;
  DateTime content_date_start = DateTime.now();
  DateTime content_date_end = DateTime.now();

  //Controller.
  Future getContent() async {
    db.getConnection().then((conn) {
      String sql =
          'SELECT * FROM content WHERE id = ' + widget.passIdContent.toString();
      conn.query(sql).then((results) {
        for (var row in results) {
          setState(() {
            //Mapping.
            content_title = row['content_title'];
            content_desc = row['content_desc'].toString();
            content_attach = row['content_attach'];
            content_tag = row['content_tag'];
            content_loc = row['content_loc'];
            content_date_start = row['content_date_start'];
            content_date_end = row['content_date_end'];
          });
        }
      });
      conn.close();
    });
  }

  //Convert date.
  GetContentDate(dateStart, dateEnd) {
    //Initial variable.
    var monthStart = DateFormat("MM").format(dateStart).toString();
    var dayStart = DateFormat("dd").format(dateStart).toString();
    var yearStart = DateFormat("yyyy").format(dateStart).toString();
    var monthEnd = DateFormat("MM").format(dateEnd).toString();
    var dayEnd = DateFormat("dd").format(dateEnd).toString();
    var yearEnd = DateFormat("yyyy").format(dateEnd).toString();
    var result = "";

    if (yearStart == yearEnd) {
      if (monthStart == monthEnd) {
        if (dayStart == dayEnd) {
          result =
              "$dayStart ${DateFormat("MMM").format(dateStart)} $yearStart";
        } else {
          result =
              "$dayStart-$dayEnd ${DateFormat("MMM").format(dateStart)} $yearStart";
        }
      } else {
        result =
            "$dayStart  ${DateFormat("MMM").format(dateStart)}-$dayEnd ${DateFormat("MMM").format(dateEnd)} $yearStart";
      }
    } else {
      result =
          "$dayStart  ${DateFormat("MMM").format(dateStart)} $yearStart-$dayEnd ${DateFormat("MMM").format(dateEnd)} $yearEnd";
    }

    return TextSpan(
        text: result,
        style: TextStyle(
            color: primaryColor,
            fontSize: textMD,
            fontWeight: FontWeight.w500));
  }

  Widget GetTag(tag) {
    return Container(
      margin: const EdgeInsets.only(right: 5, left: 5),
      child: ElevatedButton.icon(
        onPressed: () {
          // Respond to button press
        },
        icon: Icon(
          Icons.circle,
          size: textSM,
          color: Colors.green,
        ),
        label: Text("DKV", style: TextStyle(fontSize: textXSM)),
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(roundedLG2),
          )),
          backgroundColor: MaterialStatePropertyAll<Color>(primaryColor),
        ),
      ),
    );
  }

  GetLocation(loc) {}

  @override
  void initState() {
    super.initState();
    getContent();
  }

  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: fullHeight * 0.3,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/content/content-2.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: fullHeight * 0.28),
            height: fullHeight * 0.8,
            width: fullWidth,
            padding: EdgeInsets.only(
                top: paddingMD, left: paddingMD, right: paddingMD),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(roundedLG2),
              color: Colors.white,
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(content_title,
                      style: TextStyle(
                          fontSize: textMD, fontWeight: FontWeight.bold)),
                  Text("Desain Komunikasi Visual - FIK",
                      style: TextStyle(
                          fontSize: textSM,
                          fontWeight: FontWeight.w500,
                          color: blackbg)),
                  Expanded(
                    child: ListView(padding: EdgeInsets.zero, children: [
                      //Tag holder.
                      Container(
                        margin: EdgeInsets.only(top: marginMT),
                        child: Wrap(children: <Widget>[GetTag(content_tag)]),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: marginMT),
                          child: Text(content_desc,
                              style:
                                  TextStyle(color: blackbg, fontSize: textSM)))
                    ]),
                  ),
                  Container(
                      margin: EdgeInsets.all(marginMT),
                      child: Column(
                        children: [
                          Row(children: [
                            TextButton.icon(
                              onPressed: () {
                                // Respond to button press
                              },
                              icon: Icon(Icons.location_on_outlined,
                                  size: 22, color: primaryColor),
                              label: Text(GetLocation(content_loc).toString(),
                                  style: TextStyle(
                                      fontSize: textMD, color: primaryColor)),
                            ),
                            const Spacer(),
                            RichText(
                              text: TextSpan(
                                children: [
                                  WidgetSpan(
                                    child: Icon(Icons.calendar_month,
                                        size: 22, color: primaryColor),
                                  ),
                                  GetContentDate(
                                      content_date_start, content_date_end)
                                ],
                              ),
                            )
                          ]),
                          RichText(
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Icon(Icons.access_time,
                                      size: 22, color: primaryColor),
                                ),
                                TextSpan(
                                    text:
                                        " ${DateFormat("HH:mm a").format(content_date_start).toString()} - ${DateFormat("HH:mm a").format(content_date_end).toString()} WIB",
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontSize: textMD,
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                          )
                        ],
                      )),
                  SizedBox(
                      width: fullWidth,
                      child: ElevatedButton(
                        onPressed: () {
                          // Respond to button press
                        },
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(roundedLG2),
                          )),
                          backgroundColor:
                              MaterialStatePropertyAll<Color>(primaryColor),
                        ),
                        child: const Text('Save Event'),
                      ))
                ]),
          )
        ],
      ),
    );
  }
}
