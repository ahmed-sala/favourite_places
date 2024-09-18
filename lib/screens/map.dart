import 'package:favourite_places/models/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    this.location = const PlaceLocation(latitude: 37.422, longitude: -122.084, address: ''),
    this.isSelecting = true,
  });

  final bool isSelecting;
  final PlaceLocation location;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _selectedLocation;

  void _selectLocation(TapPosition tapPosition, LatLng position) {
    setState(() {
      _selectedLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use the selected location if in selecting mode, otherwise use the location from the constructor
    final displayLocation = _selectedLocation ?? LatLng(widget.location.latitude, widget.location.longitude);

    return Scaffold(
      appBar: AppBar(
        title: widget.isSelecting
            ? const Text('Select a location')
            : const Text('Your place'),
        actions: [
          if (widget.isSelecting && _selectedLocation != null)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                Navigator.of(context).pop(_selectedLocation);
              },
            ),
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          onTap: widget.isSelecting ? _selectLocation : null,
          initialCenter: displayLocation,
          initialZoom: 11,
          interactionOptions: InteractionOptions(
            flags: ~InteractiveFlag.doubleTapZoom,
          ),
        ),
        children: [
          openStreetMapTileLayer,
          MarkerLayer(markers: [
            Marker(
              point: displayLocation,
              width: 60,
              height: 60,
              alignment: Alignment.centerLeft,
              child: const Icon(
                Icons.location_on,
                size: 60,
                color: Colors.red,
              ),
            ),
          ]),
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
