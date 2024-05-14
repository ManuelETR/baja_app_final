import 'package:flutter/material.dart';
import 'package:baja_app/dominio/user.dart';
import 'package:baja_app/services/firebase_auth_service.dart';

class ProfileSettingsScreen extends StatefulWidget {
  final UserM user;

  const ProfileSettingsScreen({Key? key, required this.user}) : super(key: key);

  @override
  _ProfileSettingsScreenState createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  late TextEditingController _nameController;
  late TextEditingController _lastNameController; // Nuevo controlador para el apellido
  late TextEditingController _bioController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _websiteController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _lastNameController = TextEditingController(text: widget.user.lastName); // Inicialización del controlador de apellido
    _bioController = TextEditingController(text: widget.user.bio);
    _phoneController = TextEditingController(text: widget.user.phone);
    _addressController = TextEditingController(text: widget.user.address);
    _websiteController = TextEditingController(text: widget.user.website);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _bioController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  void _saveChanges() async {
  setState(() {
    _isLoading = true;
  });

  final updatedFields = <String, dynamic>{};

  if (_nameController.text != widget.user.name) {
    updatedFields['name'] = _nameController.text;
  }
  if (_lastNameController.text != widget.user.lastName) {
    updatedFields['lastName'] = _lastNameController.text;
  }
  if (_bioController.text != widget.user.bio) {
    updatedFields['bio'] = _bioController.text;
  }
  if (_phoneController.text != widget.user.phone) {
    updatedFields['phone'] = _phoneController.text;
  }
  if (_addressController.text != widget.user.address) {
    updatedFields['address'] = _addressController.text;
  }
  if (_websiteController.text != widget.user.website) {
    updatedFields['website'] = _websiteController.text;
  }

  if (updatedFields.isNotEmpty) {
    final authService = FirebaseAuthService();
    await authService.updateUserFieldsInFirestore(widget.user.uid, updatedFields);

    // Actualizar el objeto usuario con los nuevos valores
    widget.user.name = _nameController.text;
    widget.user.lastName = _lastNameController.text;
    widget.user.bio = _bioController.text;
    widget.user.phone = _phoneController.text;
    widget.user.address = _addressController.text;
    widget.user.website = _websiteController.text;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Cambios guardados')),
  );

  setState(() {
    _isLoading = false;
  });

  // Devolver los datos actualizados y regresar a la pantalla anterior
  Navigator.of(context).pop(widget.user);
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
          'Ajustes del Perfil',
          style: TextStyle(fontSize: 23, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Nombre'),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(labelText: 'Apellido'),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _bioController,
                      decoration: const InputDecoration(labelText: 'Bio'),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(labelText: 'Teléfono'),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(labelText: 'Dirección'),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _websiteController,
                      decoration: const InputDecoration(labelText: 'Sitio Web'),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: _saveChanges,
                        child: const Text('Guardar Cambios'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
