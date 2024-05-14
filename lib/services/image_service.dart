import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageService {
  final ImagePicker _picker = ImagePicker();

  Future<String?> chooseAndUploadImage(String userId) async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final File imageFile = File(pickedFile.path);
        final String fileName = '$userId/${DateTime.now().millisecondsSinceEpoch}.png';

        final ref = FirebaseStorage.instance.ref().child('profile_images').child(fileName);
        await ref.putFile(imageFile);

        final String imageUrl = await ref.getDownloadURL();
        return imageUrl;
      }
    } catch (e) {
      print('An error occurred while choosing and uploading image: $e');
    }
    return null;
  }
}
