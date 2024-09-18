import 'package:favourite_places/models/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'map.dart';

class PlaceDetails extends StatelessWidget {
  const PlaceDetails({super.key, required this.place});
  final Place place;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
      ),
      body: Stack(
        children: [
          Image.file(
            place.image,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) =>  MapScreen(
                            location: place.location,
                            isSelecting: false,
                          ),

                      ),
                    );
                  },
                  child: Container(
                    width: 300,
                    height: 300,
                    margin: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 24,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle, // Make the container circular
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: FlutterMap(
                        options: MapOptions(
                          initialCenter: LatLng(
                            place.location.latitude,
                            place.location.longitude,
                          ),
                          initialZoom: 11,
                          interactionOptions: InteractionOptions(
                            flags: ~InteractiveFlag.doubleTapZoom,
                          ),
                        ),
                        children: [
                          openStreetMapTileLayer,
                          MarkerLayer(markers: [
                            Marker(
                              point: LatLng(
                                place.location.latitude,
                                place.location.longitude,
                              ),
                              width: 60,
                              height: 60,
                              alignment: Alignment.centerLeft,
                              child: Icon(Icons.location_on, size: 60, color: Colors.red),
                            ),
                          ]),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Colors.black54,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 24,
                  ),
                  child: Column(
                    children: [
                      Text(
                        place.title,
                        style: const TextStyle(
                          fontSize: 26,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        place.location.address,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TileLayer get openStreetMapTileLayer {
    return TileLayer(
      urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'dev.fleaflet.flutter_map.example',
    );
  }
}
