import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class OsmWidget extends StatefulWidget {
  const OsmWidget(
      {required this.setData,
      required this.userLat,
      required this.userLng,
      required this.sellerLat,
      required this.sellerLng});

  final Function setData;
  final double userLat;

  final double userLng;

  final double sellerLat;

  final double sellerLng;

  @override
  State<OsmWidget> createState() => _OsmWidgetState();
}

class _OsmWidgetState extends State<OsmWidget> {

  MapController controller = MapController(
    initMapWithUserPosition: false,
    // initPosition: GeoPoint(latitude: 47.4358055, longitude: 8.4737324),
    initPosition: GeoPoint(latitude: 25.7447, longitude: 85.0138),
    areaLimit: BoundingBox(
      east: 10.4922941,
      north: 47.8084648,
      south: 45.817995,
      west: 5.9559113,
    ),
  );

  void seeLocation() async {

    RoadInfo roadInfo = await controller.drawRoad(
      // GeoPoint(latitude: 25.7447, longitude: 85.0138),
      // GeoPoint(latitude: 25.8309, longitude: 84.8615),

      GeoPoint(latitude: widget.sellerLat, longitude: widget.sellerLng),
      GeoPoint(latitude: widget.userLat, longitude: widget.userLng),
      roadType: RoadType.car,
      // intersectPoint : [ GeoPoint(latitude: 47.4361, longitude: 8.6156), GeoPoint(latitude: 47.4481, longitude: 8.6266)],
      roadOption: const RoadOption(
        roadWidth: 10,
        roadColor: Colors.blue,
        showMarkerOfPOI: false,
        zoomInto: true,
      ),
    );
    print(
        "${roadInfo.distance}km ****************************************************************************************");
    print("${roadInfo.duration}sec");
    widget.setData('00/00/00', roadInfo.distance, roadInfo.duration! / 4200);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    Timer(const Duration(seconds: 2), () {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    seeLocation();
    return OSMFlutter(
      controller: controller,
      trackMyPosition: false,
      initZoom: 12,
      minZoomLevel: 8,
      maxZoomLevel: 14,
      stepZoom: 1.0,
      userLocationMarker: UserLocationMaker(
        personMarker: const MarkerIcon(
          icon: Icon(
            Icons.location_history_rounded,
            color: Colors.red,
            size: 48,
          ),
        ),
        directionArrowMarker: const MarkerIcon(
          icon: Icon(
            Icons.double_arrow,
            size: 48,
          ),
        ),
      ),
      roadConfiguration: RoadConfiguration(
        startIcon: const MarkerIcon(
          icon: Icon(
            Icons.person,
            size: 64,
            color: Colors.brown,
          ),
        ),
        roadColor: Colors.yellowAccent,
      ),
      markerOption: MarkerOption(
          defaultMarker: const MarkerIcon(
        icon: Icon(
          Icons.person_pin_circle,
          color: Colors.blue,
          size: 56,
        ),
      )),
    );
  }
}
