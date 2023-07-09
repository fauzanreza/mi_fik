import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Modules/Helpers/converter.dart';
import 'package:mi_fik/Modules/Helpers/validation.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationButton extends StatefulWidget {
  const LocationButton({Key key, this.passLocation, this.passSlugName})
      : super(key: key);
  final List passLocation;
  final String passSlugName;

  @override
  StateLocationButton createState() => StateLocationButton();
}

class StateLocationButton extends State<LocationButton>
    with SingleTickerProviderStateMixin {
  //Initial variable.
  //_MapsPageState(passIdFakses);
  GoogleMapController googleMapController;
  Marker _origin;
  Marker _destination;
  Position position;
  String mylong = "", mylat = "";
  StreamSubscription<Position> positionStream;
  Uint8List bytes;

  @override
  void initState() {
    checkGps(getLocation());
    super.initState();
    googleMapController;
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    mylong = position.longitude.toString();
    mylat = position.latitude.toString();

    setState(() {
      //refresh UI
    });

    // LocationSettings locationSettings = const LocationSettings(
    //   accuracy: LocationAccuracy.high,
    //   distanceFilter: 100,
    // );

    // String imgurl =
    //     "https://leonardhors.site/public/assets/img/87409344219_PAS_FOTO_2.jpg";
    // bytes = (await NetworkAssetBundle(Uri.parse(imgurl)).load(imgurl))
    //     .buffer
    //     .asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    double fullWidth = MediaQuery.of(context).size.width;

    //Get location name and coordinate from json.
    if (widget.passLocation.length == 2) {
      var coordinate = widget.passLocation[1]['detail'].split(', ');
      double lat = double.parse(coordinate[0]);
      double lng = double.parse(coordinate[1]);

      //Maps starting point.
      final initialCameraPosition = CameraPosition(
        target: LatLng(lat, lng),
        zoom: 14,
      );

      return InkWell(
          onTap: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                  insetPadding: EdgeInsets.all(spaceXMD),
                  contentPadding: EdgeInsets.all(spaceLG),
                  content: SizedBox(
                    height:
                        fullWidth, //Pop up height based on fullwidth (Square maps).
                    width: fullWidth,
                    child: Column(children: [
                      Flexible(
                        child: GoogleMap(
                          myLocationButtonEnabled: false,
                          zoomControlsEnabled: false,
                          myLocationEnabled: true,
                          initialCameraPosition: initialCameraPosition,
                          onMapCreated: (controller) =>
                              googleMapController = controller,
                          markers: {
                            if (_origin != null) _origin,
                            if (_destination != null) _destination,
                            Marker(
                              markerId: MarkerId(widget.passSlugName),
                              infoWindow: InfoWindow(
                                  title: getLocationName(widget.passLocation)),
                              icon: BitmapDescriptor.defaultMarkerWithHue(
                                  BitmapDescriptor.hueOrange),
                              position: LatLng(lat, lng),
                            ),
                            // Marker(
                            //   markerId: const MarkerId("0"),
                            //   infoWindow: const InfoWindow(title: "You"),

                            //   icon: BitmapDescriptor.defaultMarkerWithHue(
                            //       BitmapDescriptor.hueOrange),
                            //   // icon: BitmapDescriptor.fromBytes(bytes),
                            //   position: LatLng(
                            //       double.parse(mylat), double.parse(mylong)),
                            // )
                          },
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.zero,
                          margin: EdgeInsets.only(top: spaceLG),
                          width: fullWidth,
                          height: btnHeightMD - 10,
                          child: ElevatedButton(
                            onPressed: () async {
                              //Navigate through google maps w/ direction.
                              String googleUrl =
                                  //'https://www.google.com/maps/dir/Current+Location/?api=1&query=${lat},${lng}';
                                  'https://www.google.com/maps/dir/Current+Location/$lat,$lng';
                              if (await canLaunchUrl(Uri.parse(googleUrl))) {
                                await launchUrl(Uri.parse(googleUrl));
                              } else {
                                Get.snackbar(
                                    "Error", "Could not open the map".tr,
                                    backgroundColor: whiteColor);
                                // throw 'Could not open the map'.tr;
                              }
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                              backgroundColor:
                                  MaterialStatePropertyAll<Color>(primaryColor),
                            ),
                            child: const Text('Navigate'),
                          ))
                    ]),
                  ))),
          child: RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                  child: Icon(Icons.location_on_outlined,
                      size: 20, color: darkColor),
                ),
                TextSpan(
                    text: getLocationName(widget.passLocation),
                    style: TextStyle(fontSize: textXMD, color: darkColor)),
              ],
            ),
          ));
    } else {
      return InkWell(
          onTap: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => const FailedDialog(
                  text:
                      "Something error with event location, please contact admin",
                  type: "event")),
          child: RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                  child: Icon(Icons.location_on_outlined,
                      size: 20, color: darkColor),
                ),
                TextSpan(
                    text: getLocationName(widget.passLocation),
                    style: TextStyle(fontSize: textXMD, color: darkColor)),
              ],
            ),
          ));
    }
  }

  // //Check this!!!!
  // @override
  // void dispose() {
  //   super.dispose();
  //   googleMapController.dispose();
  // }
}
