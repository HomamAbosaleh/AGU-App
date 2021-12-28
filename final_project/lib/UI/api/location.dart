import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../services/http.dart';
import 'package:final_project/theme/theme.dart';

class Location extends StatefulWidget {
  const Location({Key? key}) : super(key: key);
  @override
  State<Location> createState() => LocationState();
}


class LocationState extends State<Location> {
  final Completer<GoogleMapController> _controller = Completer();
  bool isData = false;
  Set<Marker> _markers = {};

  void getLocation() async {
    Position position = await Http().getLocation();
    setState(() {
      _kGooglePlex = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 14.4746,
      );
      isData = true;
    });
  }

  @override
  void initState(){
    super.initState();
    getLocation();
  }

  late CameraPosition _kGooglePlex;

  static const CameraPosition _Agu = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(38.73719850955575, 35.47356217597683),
      tilt: 30.440717697143555,
      zoom: 16.151926040649414
  );

  List<Marker> markerList = [
    Marker(
        markerId: MarkerId('id-1'),
        position: LatLng(38.73718838595613, 35.4740012891398),
        infoWindow: InfoWindow(
          title: 'Buyuk Ambar Building',
          snippet: 'AKA BA Building or first home ',
        )
    ),
    Marker(
      markerId: MarkerId('id-2'),
      position: LatLng(38.736946996532865, 35.473508676889814),
      infoWindow: InfoWindow(
          title: 'Steel Building',
          snippet: 'A and B building'
      ),
    ),
    Marker(
        markerId: MarkerId('id-3'),
        position: LatLng(38.73852535127591, 35.47487684453439),
        infoWindow: InfoWindow(
          title: 'Fabrika Building',
          snippet: 'F building',
        )
    ),
    Marker(
      markerId: MarkerId('id-4'),
      position: LatLng(38.740409749084975, 35.47555554794697),
      infoWindow: InfoWindow(
        title: 'Resarch Building',
        snippet: 'Lab Building',
      ),
    ),
  ];

  void _onMapCreated(GoogleMapController){
    setState(() {
      _markers.addAll(markerList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isData == false ? const Center(child: CircularProgressIndicator(),) : GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _Agu,
        onMapCreated: _onMapCreated,
        markers: _markers,
      ),
   /*   floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(0.0,0.0,245.0,5.0),
        child: FloatingActionButton.extended(
          onPressed: _goToAgu,
          label: Text('To the Uni!', style: Theme.of(context).textTheme.headline6),
          icon:  Icon(FontAwesomeIcons.university,color: Theme.of(context).cardTheme.color),
        ),
      ),*/
    );
  }

  Future<void> _goToAgu() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_Agu));
  }
  Future<Position> locationGet() async {
    var currentLocation;
    try {
      currentLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }
}
