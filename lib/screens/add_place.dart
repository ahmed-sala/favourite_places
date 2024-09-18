import 'dart:ffi';
import 'dart:io';

import 'package:favourite_places/providers/user_places.dart';
import 'package:favourite_places/widgets/image_input.dart';
import 'package:favourite_places/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPlace extends ConsumerStatefulWidget {
  const AddPlace({super.key});
  @override
  ConsumerState<AddPlace> createState() => _AddPlaceState();
}

class _AddPlaceState extends ConsumerState<AddPlace> {
  final _titleController = TextEditingController();

  File? _selectedImage;
  double? _latitude;
  double? _longitude;
  String? _address;
  void _savePlace() {
    final enteredTitle = _titleController.text;
    if (enteredTitle.isEmpty||_selectedImage==null) {
      return;
    }
    ref.read(userPlacesProvider.notifier).addPlace(enteredTitle, _selectedImage!,_latitude!,_longitude!,_address!);
    Navigator.of(context).pop();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _titleController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new place'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
             Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
                decoration: InputDecoration(
                  labelText: 'Title',

                ),
                controller: _titleController,
              ),
            ),
            const SizedBox(height: 16),
            ImageInput(
              onImageSelected: (image) {
                _selectedImage = image;
              },
            ),
            const SizedBox(height: 16),
            LocationInput(
              onSelectPlace: (latitude, longitude, address) {
                _latitude = latitude;
                _longitude = longitude;
                _address = address;
              },
            ),
            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: _savePlace,
              icon: const Icon(Icons.add),
              label: const Text('Add place'),
            ),
          ],
        ),
      ),
    );
  }
}
