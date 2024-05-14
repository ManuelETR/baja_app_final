import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:baja_app/dominio/user.dart';
import 'package:baja_app/services/firebase_auth_service.dart';
import 'package:baja_app/presentation/profile_settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserM? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    setState(() {
      _isLoading = true;
    });

    final authService = FirebaseAuthService();
    final user = await authService.getUserProfile(widget.userId);

    setState(() {
      _user = user;
      _isLoading = false;
    });
  }

  Future<File?> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  Future<String?> _uploadImage(File imageFile) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_profiles')
          .child('${widget.userId}.jpg');
      await storageRef.putFile(imageFile);
      final downloadUrl = await storageRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _updateProfileImage(String imageUrl) async {
    final authService = FirebaseAuthService();
    await authService.updateUserFieldsInFirestore(widget.userId, {'imageUrl': imageUrl});
    await _getUserData();  // Recargar el perfil después de actualizar la imagen
  }

  void _changeProfileImage() async {
    final imageFile = await _pickImage();
    if (imageFile != null) {
      setState(() {
        _isLoading = true;
      });

      final imageUrl = await _uploadImage(imageFile);
      if (imageUrl != null) {
        await _updateProfileImage(imageUrl);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF053F93),
        title: const Text(
          'Perfil',
          style: TextStyle(fontSize: 23, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _user == null
              ? const Center(child: Text('No profile data'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: _user!.imageUrl.isNotEmpty ? NetworkImage(_user!.imageUrl) : null,
                              child: _user!.imageUrl.isEmpty ? const Icon(Icons.person, size: 50) : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: IconButton(
                                icon: const Icon(Icons.camera_alt, color: Colors.white),
                                onPressed: _changeProfileImage,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      ListTile(
                        leading: const Icon(Icons.person),
                        title: const Text('Nombre'),
                        subtitle: Text('${_user!.name} ${_user!.lastName}'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.info),
                        title: const Text('Bio'),
                        subtitle: Text(_user!.bio),
                      ),
                      ListTile(
                        leading: const Icon(Icons.phone),
                        title: const Text('Teléfono'),
                        subtitle: Text(_user!.phone),
                      ),
                      ListTile(
                        leading: const Icon(Icons.location_on),
                        title: const Text('Dirección'),
                        subtitle: Text(_user!.address),
                      ),
                      ListTile(
                        leading: const Icon(Icons.language),
                        title: const Text('Sitio Web'),
                        subtitle: Text(_user!.website),
                      ),
                      ListTile(
                        leading: const Icon(Icons.email),
                        title: const Text('Email'),
                        subtitle: Text(_user!.email),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            final updatedUser = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ProfileSettingsScreen(user: _user!)),
                            );

                            if (updatedUser != null) {
                              setState(() {
                                _user = updatedUser;
                              });
                            }
                          },
                          child: const Text('Editar Perfil'),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
