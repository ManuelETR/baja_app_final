import 'package:baja_app/presentation/index.dart';

class UserM {
  String uid;
  String email;
  String name;
  String lastName;
  String bio;
  String phone;
  String address;
  String website;
  String imageUrl;

  UserM({
    required this.uid,
    required this.email,
    required this.name,
    required this.lastName,
    required this.bio,
    required this.phone,
    required this.address,
    required this.website,
    required this.imageUrl,
  });

  factory UserM.fromFirebaseUser(User user) {
    return UserM(
      uid: user.uid,
      email: user.email ?? '',
      name: '', // Inicializa otros campos vacíos
      lastName: '',
      bio: '',
      phone: '',
      address: '',
      website: '',
      imageUrl: '',
    );
  }

  UserM? copyWith({required String imageUrl}) {
    return null;
  }
}
