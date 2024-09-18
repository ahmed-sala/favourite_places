import 'dart:io';

import 'package:uuid/uuid.dart';

class Place{
  Place({required this.title,required this.image,required this.location,String? id}): id = id ?? const Uuid().v4();
  final String title;
  final String id;
  final File image;
  final PlaceLocation location;
}

class PlaceLocation{
  const PlaceLocation({required this.latitude,required this.longitude,required this.address});
  final double latitude;
  final double longitude;
  final String address ;
}