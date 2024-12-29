import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';

class UploadItemScreen extends StatefulWidget {
  const UploadItemScreen({Key? key}) : super(key: key);

  @override
  State<UploadItemScreen> createState() => _UploadItemScreenState();
}

class _UploadItemScreenState extends State<UploadItemScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  bool _isLoading = false;
  List<XFile> _images = [];
  Position? _currentPosition;
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null) {
      setState(() {
        _images = pickedFiles;
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied.');
      }

      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
      });

      _showMessage(
          'Location fetched: (${position.latitude}, ${position.longitude})');
    } catch (e) {
      _showMessage('Error fetching location: $e');
    }
  }

  Future<void> _uploadItem() async {
    final String name = _nameController.text.trim();
    final String description = _descriptionController.text.trim();
    final String price = _priceController.text.trim();

    if (name.isEmpty ||
        description.isEmpty ||
        price.isEmpty ||
        _images.isEmpty ||
        _currentPosition == null) {
      _showMessage('Please fill in all fields, select images, and get location.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Upload images and get public URLs
      List<String> imageUrls = await _uploadImagesToSupabase();

      // Insert item details into the database
      final response = await _supabase.from('items').insert({
        'user_id': _supabase.auth.currentUser?.id,
        'name': name,
        'description': description,
        'price': double.tryParse(price),
        'images': imageUrls,
        'latitude': _currentPosition?.latitude,
        'longitude': _currentPosition?.longitude,
      });

      if (response.error == null) {
        _showMessage('Item uploaded successfully!');
        Navigator.pop(context);
      } else {
        _showMessage('Error uploading item: ${response.error!.message}');
      }
    } catch (e) {
      _showMessage('Error uploading item: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<List<String>> _uploadImagesToSupabase() async {
    List<String> imageUrls = [];

    for (XFile image in _images) {
      try {
        final Uint8List fileBytes = await image.readAsBytes();
        final String fileName =
            'item_${DateTime.now().millisecondsSinceEpoch}_${image.name}';

        final response = await _supabase.storage
            .from('item-images')
            .uploadBinary(fileName, fileBytes, fileOptions: const FileOptions(upsert: true));

        if (response.isEmpty) {
          throw Exception('Failed to upload image.');
        }

        final String publicUrl =
        _supabase.storage.from('item-images').getPublicUrl(fileName);

        imageUrls.add(publicUrl);
      } catch (e) {
        throw Exception('Error uploading image: $e');
      }
    }

    return imageUrls;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Item'),
        backgroundColor: Colors.lightGreen,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Item Name', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Enter item name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Description', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Enter item description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Price', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter price',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Photos', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _pickImages,
              icon: const Icon(Icons.photo_library),
              label: const Text('Pick Images'),
            ),
            const SizedBox(height: 8),
            _images.isNotEmpty
                ? Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _images
                  .map((image) => ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  image.path,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ))
                  .toList(),
            )
                : const Text('No images selected.', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            const Text('Location', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _getCurrentLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Use Current Location'),
            ),
            const SizedBox(height: 8),
            _currentPosition != null
                ? Text(
              'Location: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}',
              style: const TextStyle(color: Colors.grey),
            )
                : const Text(
              'No location selected.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _uploadItem,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'Upload Item',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
