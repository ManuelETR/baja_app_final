import 'package:baja_app/widgets/login/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:baja_app/dominio/user.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showToast(message: 'The email address is already in use.');
      } else {
        showToast(message: 'An error occurred: ${e.code}');
      }
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        showToast(message: 'Invalid email or password.');
      } else {
        showToast(message: 'An error occurred: ${e.code}');
      }
    }
    return null;
  }

  Future<void> updateUserProfile(String displayName, String photoURL) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updateDisplayName(displayName);
        await user.updatePhotoURL(photoURL);
        await user.reload();
        user = _auth.currentUser;
        if (user != null) {
          showToast(message: 'Profile updated successfully.');
        } else {
          showToast(message: 'Failed to update profile.');
        }
      }
    } catch (e) {
      showToast(message: 'An error occurred while updating profile: $e');
    }
  }

  Future<void> updateUserFieldsInFirestore(String uid, Map<String, dynamic> updatedFields) async {
    try {
      await _firestore.collection('users').doc(uid).update(updatedFields);
      showToast(message: 'Profile updated successfully.');
    } catch (e) {
      showToast(message: 'An error occurred while updating profile: $e');
    }
  }

  Future<UserM?> getUserProfile(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserM(
          uid: doc.id,
          email: doc['email'] ?? '',
          name: doc['name'] ?? '',
          lastName: doc['lastName'] ?? '',
          bio: doc['bio'] ?? '',
          phone: doc['phone'] ?? '',
          address: doc['address'] ?? '',
          website: doc['website'] ?? '',
          imageUrl: doc['imageUrl'] ?? '',
        );
      } else {
        showToast(message: 'Profile does not exist.');
      }
    } catch (e) {
      showToast(message: 'An error occurred while fetching profile: $e');
    }
    return null;
  }
}
