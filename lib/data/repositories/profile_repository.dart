import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';

/// Profile text is stored per account in Firestore. Photos stay on this device.
/// A local photo is NOT synchronized across devices or restored after uninstall.
class ProfileRepository {
  ProfileRepository(this.auth, this.firestore);

  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  User get user {
    final current = auth.currentUser;
    if (current == null) throw StateError('Please sign in first.');
    return current;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> watchProfile() =>
      firestore.collection('users').doc(user.uid).snapshots();

  Future<void> updateName(String name) async {
    final value = name.trim();
    if (value.isEmpty) throw ArgumentError('Name cannot be empty.');
    final current = user;
    await firestore.collection('users').doc(current.uid).set({
      'name': value,
      'email': current.email,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    await current.updateDisplayName(value);
  }

  Future<File> _photoFile(String uid) async {
    final directory = await getApplicationDocumentsDirectory();
    final folder = Directory('${directory.path}/streetbite_profile_photos');
    if (!await folder.exists()) await folder.create(recursive: true);
    return File('${folder.path}/$uid.jpg');
  }

  Future<File?> localPhoto() async {
    final current = user;
    final file = await _photoFile(current.uid);
    return await file.exists() ? file : null;
  }

  Future<File> saveLocalPhoto(File selected) async {
    final uid = user.uid;
    final destination = await _photoFile(uid);
    // image_picker is configured for JPEG compression in the UI.
    final temp = File('${destination.path}.tmp');
    await selected.copy(temp.path);
    // Replacing the previous avatar is safe even when the source is temporary.
    if (await destination.exists()) await destination.delete();
    return temp.rename(destination.path);
  }
}
