import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


import '../../services/http.dart';

class Location extends StatefulWidget {
  const Location({Key? key}) : super(key: key);
  @override
  State<Location> createState() => LocationState();
}

class LocationState extends State<Location> {
  MapType _currMapType = MapType.normal;
  final Completer<GoogleMapController> _controller = Completer();
  bool isData = false;
  Set<Marker> markers = {};

  void getLocation() async {
    Position position = await Http().getLocation();
    if (!mounted) return;
    try {
      setState(() {
        _kGooglePlex = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 14.4746,
        );
        isData = true;
      });
    } catch (ex) {
      print(ex.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  late CameraPosition _kGooglePlex;

  static const CameraPosition agu = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(38.73719850955575, 35.47356217597683),
      tilt: 30.440717697143555,
      zoom: 16.151926040649414);

  List<Marker> markerList = const [
    Marker(
        markerId: MarkerId('id-1'),
        position: LatLng(38.73718838595613, 35.4740012891398),
        infoWindow: InfoWindow(
          title: 'Buyuk Ambar Building',
          snippet: 'AKA BA Building',
        )),
    Marker(
      markerId: MarkerId('id-2'),
      position: LatLng(38.736946996532865, 35.473508676889814),
      infoWindow: InfoWindow(title: 'Steel Building', snippet: 'A and B building'),
    ),
    Marker(
        markerId: MarkerId('id-3'),
        position: LatLng(38.73852535127591, 35.47487684453439),
        infoWindow: InfoWindow(
          title: 'Fabrika Building',
          snippet: 'F building',
        )),
    Marker(
      markerId: MarkerId('id-4'),
      position: LatLng(38.74041456900319, 35.47494951684609),
      infoWindow: InfoWindow(
        title: 'Resarch Building',
        snippet: 'Lab Building',
      ),
    ),
  ];

  void _onMapCreated(googleMapController) {
    if (!mounted) return;
    setState(() {
      markers.addAll(markerList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isData == false
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      'Please leave and come back to this page if it\'s your first time loading the app',
                      textAlign: TextAlign.center,
                    ),
                  )

                ],
              ),
            )
          : GoogleMap(
              mapType: _currMapType,
              initialCameraPosition: agu,
              onMapCreated: _onMapCreated,
              markers: markers,
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.view_in_ar),
        backgroundColor: Colors.white,
        onPressed: _toggleMapType,
        heroTag: null,
      ),
    );
  }
  void _toggleMapType(){
    setState(() {
      _currMapType = (_currMapType == MapType.normal) ? MapType.satellite : MapType.normal;
    });
  }

  Future<void> _goToAgu() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(agu));
  }

  Future<Position> locationGet() async {
    var currentLocation;
    try {
      currentLocation = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }
}
