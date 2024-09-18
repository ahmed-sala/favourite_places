import 'dart:io';

import 'package:favourite_places/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart'as syspaths;
import 'package:sqflite/sqflite.dart'as sql;
import 'package:sqflite/sqlite_api.dart';


Future<Database>_getDatabase()async{
  final getDataBasw=await sql.getDatabasesPath();
  return sql.openDatabase('$getDataBasw/places.db',onCreate: (db,version){
    return db.execute('CREATE TABLE user_places(id TEXT PRIMARY KEY,title TEXT,image TEXT,latitude REAL,longitude REAL,address TEXT)');
  },version: 1);
}
class UserPlacesNotifier extends StateNotifier<List<Place>>{
  UserPlacesNotifier(): super(const []);

  Future<void> loadPlaces()async{
    final db=await _getDatabase();
    final placesData = await db.query('user_places');
    final places=placesData.map((row){
      return Place(
        id: row['id'] as String,
        title: row['title'] as String,
        image: File(row['image'] as String),
        location: PlaceLocation(latitude: row['latitude'] as double,longitude: row['longitude'] as double,address: row['address'] as String),
      );
    });
    state = places.toList();
  }

  void addPlace(String title, File imagePath,double latitude,double longitude,String address)async{
    final appDir =await syspaths.getApplicationDocumentsDirectory();
    final fileName = imagePath.path.split('/').last;
    final savedImage = await imagePath.copy('${appDir.path}/$fileName');


    final newPlace = Place(
      title: title,
      image: savedImage,
      location: PlaceLocation(latitude: latitude,longitude: longitude,address: address),
    );

   final db = await _getDatabase();
    await db.insert('user_places', {
      'id':newPlace.id,
      'title':newPlace.title,
      'image':newPlace.image.path,
      'latitude':newPlace.location.latitude,
      'longitude':newPlace.location.longitude,
      'address':newPlace.location.address,
    });


    state = [...state,newPlace];


  }
}

final userPlacesProvider = StateNotifierProvider<UserPlacesNotifier, List<Place>>((ref) => UserPlacesNotifier());