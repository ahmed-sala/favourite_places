import 'package:flutter/material.dart';

import '../models/place.dart';
import '../screens/place_details.dart';

class PlacesList extends StatelessWidget {
  const PlacesList({super.key,required this.places});
  final List<Place> places;

  @override
  Widget build(BuildContext context) {
     if(places.isEmpty){
      return  Center(
        child: Text('No places yet, start adding some!',style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: Theme.of(context).colorScheme.onBackground,
        ),),
      );

  }
    return Padding(
      padding: const EdgeInsets.all(12),
      child: ListView.builder(
        itemCount: places.length,
        itemBuilder: (ctx, i) => ListTile(

          title: Text(places[i].title,style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
          ),),
          leading: CircleAvatar(
            radius: 30,
            backgroundImage: FileImage(places[i].image),
          ),
          subtitle: Text(places[i].location.address,style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
          ),),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => PlaceDetails(place: places[i]),
              ),
            );
          },
        ),
      ),
    );
  }
}
// /full/path/to/cloud_sql_proxy -dir=/cloudsql -instances=cloud-squad-project:us-central1:correct-instance-name


