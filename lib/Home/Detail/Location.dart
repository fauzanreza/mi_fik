import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mi_fik/main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationButton extends StatefulWidget {
  const LocationButton({key, this.passLocation, this.passId});
  final String passLocation;
  final int passId;

  @override
  _LocationButton createState() => _LocationButton();
}

class _LocationButton extends State<LocationButton>
    with SingleTickerProviderStateMixin {
  //_MapsPageState(passIdFakses);
  GoogleMapController _googleMapController;
  Marker _origin;
  Marker _destination;

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double fullWidth = MediaQuery.of(context).size.width;

    //Get location name and coordinate from json.
    final jsonLoc = json.decode(widget.passLocation.toString());
    var location = jsonLoc[0]['detail'];
    var coordinate = jsonLoc[1]['detail'].split(', ');
    double lat = double.parse(coordinate[0]);
    double lng = double.parse(coordinate[1]);

    //Maps starting point.
    final _initialCameraPosition = CameraPosition(
      target: LatLng(lat, lng), //Bandung
      zoom: 14,
    );

    return TextButton.icon(
      onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
              contentPadding: EdgeInsets.all(paddingMD),
              content: Container(
                height: fullWidth *
                    0.8, //Pop up height based on fullwidth (Square maps).
                child: Column(children: [
                  Flexible(
                    child: GoogleMap(
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      initialCameraPosition: _initialCameraPosition,
                      onMapCreated: (controller) =>
                          _googleMapController = controller,
                      markers: {
                        if (_origin != null) _origin,
                        Marker(
                          markerId: MarkerId(widget.passId.toString()),
                          infoWindow: InfoWindow(title: location),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueRed),
                          position: LatLng(lat, lng),
                        )
                      },
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.zero,
                      margin: EdgeInsets.only(top: paddingMD),
                      width: fullWidth,
                      height: btnHeightMD - 10,
                      child: ElevatedButton(
                        onPressed: () {
                          //
                        },
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
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
      icon: Icon(Icons.location_on_outlined, size: 22, color: primaryColor),
      label: Text(location,
          style: TextStyle(fontSize: textMD, color: primaryColor)),
    );
  }
}
