import 'package:favourite_places/models/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import '../screens/map.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelectPlace});
  final void Function(double latitude, double longitude, String address)? onSelectPlace;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  var _isGettingLocation = false;

  void _getUserLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _isGettingLocation = true;
    });

    locationData = await location.getLocation();
    if (locationData.latitude == null || locationData.longitude == null) {
      return;
    }

    // Reverse Geocoding to get address
    List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
      locationData.latitude!,
      locationData.longitude!,
    );

    geo.Placemark place = placemarks[0];
    String address =
        '${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}';
    setState(() {
      _pickedLocation = PlaceLocation(
        latitude: locationData.latitude!,
        longitude: locationData.longitude!,
        address: address,
      );
      _isGettingLocation = false;
    });

    widget.onSelectPlace!(locationData.latitude!, locationData.longitude!, address);

    print('Address: $address');
  }

  Future<void> _selectOnMap() async {
    final selectedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (ctx) => const MapScreen(),
      ),
    );

    if (selectedLocation == null) {
      return;
    }

    // Reverse Geocoding to get address
    List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
      selectedLocation.latitude,
      selectedLocation.longitude,
    );

    geo.Placemark place = placemarks[0];
    String address =
        '${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}';

    setState(() {
      _pickedLocation = PlaceLocation(
        latitude: selectedLocation.latitude,
        longitude: selectedLocation.longitude,
        address: address,
      );
    });

    widget.onSelectPlace!(
      selectedLocation.latitude,
      selectedLocation.longitude,
      address,
    );

    print('Selected Address: $address');
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Text(
      'Location Preview',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
        color: Theme.of(context).colorScheme.onBackground,
      ),
    );
    if (_isGettingLocation) {
      content = const CircularProgressIndicator();
    } else if (_pickedLocation != null) {
      content = FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(
            _pickedLocation!.latitude!,
            _pickedLocation!.longitude!,
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
                _pickedLocation!.latitude!,
                _pickedLocation!.longitude!,
              ),
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
      );
    }

    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: content,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getUserLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Current Location'),
            ),
            TextButton.icon(
              onPressed: _selectOnMap,
              icon: const Icon(Icons.map),
              label: const Text('Select on Map'),
            ),
          ],
        ),
      ],
    );
  }

  TileLayer get openStreetMapTileLayer {
    return TileLayer(
      urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'dev.fleaflet.flutter_map.example',
    );
  }
}
