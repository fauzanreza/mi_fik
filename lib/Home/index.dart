import 'package:flutter/material.dart';
import 'package:mi_fik/Others/custombg.dart';
import 'package:mi_fik/main.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: CustomPaint(
          painter: CirclePainter(),
          child: Container(
            // color: primaryColor,
            child: ListView(
                padding: EdgeInsets.only(top: fullHeight * 0.08),
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Good Morning",
                              style: TextStyle(
                                  color: whitebg,
                                  fontWeight: FontWeight.w500,
                                  fontSize: textLG)),
                          const SizedBox(height: 5),
                          Text("09:23 Am",
                              style: TextStyle(
                                  color: whitebg,
                                  fontWeight: FontWeight.bold,
                                  fontSize: textXL)),
                          SizedBox(height: fullHeight * 0.05),
                          Text("13 June 2022",
                              style:
                                  TextStyle(color: whitebg, fontSize: textMD)),
                        ]),
                  ),
                  Expanded(
                      child: Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    decoration: BoxDecoration(
                      color: mainbg,
                      borderRadius: BorderRadius.only(
                          topLeft: roundedLG, topRight: roundedLG),
                    ),
                    child: Column(children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.all(10),
                        child: Text("What's New ?",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: textLG,
                                fontWeight: FontWeight.w500)),
                      ),
                      Column(
                        children: [
                          SizedBox(
                              width: fullWidth,
                              child: IntrinsicHeight(
                                child: Stack(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: fullWidth * 0.03),
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
                                        //Action here....
                                      },
                                      child: Container(
                                          width: fullWidth * 0.82,
                                          margin:
                                              EdgeInsets.only(bottom: marginMD),
                                          transform: Matrix4.translationValues(
                                              40.0, 5.0, 0.0),
                                          decoration: BoxDecoration(
                                            color: whitebg,
                                            borderRadius:
                                                BorderRadius.all(roundedMd),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color.fromARGB(
                                                        255, 128, 128, 128)
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                height: 108.0,
                                                width: fullWidth,
                                                padding:
                                                    const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    fit: BoxFit.fitWidth,
                                                    image: const AssetImage(
                                                        'assets/content/content-2.jpg'),
                                                    colorFilter:
                                                        ColorFilter.mode(
                                                            Colors
                                                                .black
                                                                .withOpacity(
                                                                    0.5),
                                                            BlendMode.darken),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text("Just Now",
                                                          style: TextStyle(
                                                            color: whitebg,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ))
                                                    ]),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          "Open House DKV 2022",
                                                          style: TextStyle(
                                                              color: blackbg,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  textMD)),
                                                      Text(
                                                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. ",
                                                          maxLines: 4,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              color: blackbg,
                                                              fontSize: textSM))
                                                    ]),
                                              ),

                                              //Open content w/ button.
                                              Container(
                                                  transform:
                                                      Matrix4.translationValues(
                                                          0.0, 5.0, 0.0),
                                                  padding: EdgeInsets.zero,
                                                  width: fullWidth,
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      //Action here....
                                                    },
                                                    child: const Text('Detail'),
                                                    style: ButtonStyle(
                                                      shape: MaterialStateProperty.all<
                                                              RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      )),
                                                      backgroundColor:
                                                          MaterialStatePropertyAll<
                                                                  Color>(
                                                              primaryColor),
                                                    ),
                                                  ))
                                            ],
                                          )),
                                    )
                                  ],
                                ),
                              )),
                          SizedBox(
                              width: fullWidth,
                              child: IntrinsicHeight(
                                child: Stack(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: fullWidth * 0.03),
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

                                    Container(
                                        width: fullWidth * 0.82,
                                        margin:
                                            EdgeInsets.only(bottom: marginMD),
                                        transform: Matrix4.translationValues(
                                            40.0, 5.0, 0.0),
                                        decoration: BoxDecoration(
                                          color: whitebg,
                                          borderRadius:
                                              BorderRadius.all(roundedMd),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color.fromARGB(
                                                      255, 128, 128, 128)
                                                  .withOpacity(0.3),
                                              blurRadius:
                                                  10.0, // soften the shadow
                                              spreadRadius:
                                                  0.0, //extend the shadow
                                              offset: const Offset(
                                                5.0, // Move to right 10  horizontally
                                                5.0, // Move to bottom 10 Vertically
                                              ),
                                            )
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              height: 108.0,
                                              width: fullWidth,
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  fit: BoxFit.fitWidth,
                                                  image: const AssetImage(
                                                      'assets/content/content-1.jpg'),
                                                  colorFilter: ColorFilter.mode(
                                                      Colors.black
                                                          .withOpacity(0.5),
                                                      BlendMode.darken),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text("Just Now",
                                                        style: TextStyle(
                                                          color: whitebg,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ))
                                                  ]),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Open House DKV 2022",
                                                        style: TextStyle(
                                                            color: blackbg,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: textMD)),
                                                    Text(
                                                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor . ",
                                                        maxLines: 4,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            color: blackbg,
                                                            fontSize: textSM))
                                                  ]),
                                            ),
                                            Container(
                                                transform:
                                                    Matrix4.translationValues(
                                                        0.0, 5.0, 0.0),
                                                padding: EdgeInsets.zero,
                                                width: fullWidth,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    // Respond to button press
                                                  },
                                                  child: const Text('Detail'),
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStatePropertyAll<
                                                                Color>(
                                                            primaryColor),
                                                  ),
                                                ))
                                          ],
                                        )),
                                  ],
                                ),
                              )),
                        ],
                      )
                    ]),
                  ))
                ]),
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        backgroundColor: primaryColor,
        child: Icon(Icons.add, size: iconLG),
      ),
    );
  }
}
