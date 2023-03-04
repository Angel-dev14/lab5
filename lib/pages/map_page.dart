import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lab5/directions/google_directions.dart';

import '../model/directions.dart';

class MapPage extends StatefulWidget {
  final Marker eventMarker;
  final Marker? currentLocationMarker;

  MapPage(
      {super.key,
      required this.eventMarker,
      required this.currentLocationMarker}) {}

  @override
  State<StatefulWidget> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  CameraPosition? _kGooglePlex;
  Directions? _directions;

  final CameraPosition _initial = const CameraPosition(
    target: LatLng(41.99593399919513, 21.431472367447558),
    zoom: 14,
  );

  @override
  void initState() {
    _kGooglePlex = CameraPosition(
      target: widget.eventMarker.position,
      zoom: 14,
    );
  }

  _getDirections() async {
    if (widget.currentLocationMarker == null) {
      return;
    }
    final start = widget.currentLocationMarker!.position;
    final end = widget.eventMarker.position;
    final directions =
        await GoogleDirections().getDirections(start: start, end: end);
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
        CameraUpdate.newCameraPosition(CameraPosition(target: end, zoom: 14)));
    controller.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(
            southwest: directions!.bounds!.southwest,
            northeast: directions.bounds!.northeast),
        25));

    setState(() {
      _directions = directions;
    });
  }

  Set<Marker> _getMarkers() {
    if (widget.currentLocationMarker != null) {
      return {widget.eventMarker, widget.currentLocationMarker!};
    }
    return {widget.eventMarker};
  }

  Set<Polyline> _getPolyline() {
    if (_directions != null) {
      return {
        Polyline(
            polylineId: const PolylineId('event_directions'),
            color: Colors.red,
            width: 3,
            points: _directions!.polylinePoints!
                .map((e) => LatLng(e.latitude, e.longitude))
                .toList())
      };
    }
    return {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex != null ? _kGooglePlex! : _initial,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          _getDirections();
        },
        markers: _getMarkers(),
        polylines: _getPolyline(),
      ),
    );
  }
}
