import 'dart:io';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class DatabaseManager {
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  CollectionReference animalCollection =
      FirebaseFirestore.instance.collection('Animals');

  Future<void> addUser(
      String username,
      String mobileNo,
      String address,
      String registrationDate,
      String profileImageLink,
      String password,
      String about) async {
    return await usersCollection.doc(mobileNo).set({
      'username': username,
      'mobileNo': mobileNo,
      'address': address,
      'registrationDate': registrationDate,
      'profileImageLink': profileImageLink,
      'password': password,
      'about': about
    });
  }

  Future<bool> addAnimalsData(
      Map<String, String> map, String _currentMobileNo) async {
    try {
      await FirebaseFirestore.instance
          .collection("Animals")
          .doc(map['id'])
          .set(map);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentMobileNo)
          .collection('my_pets')
          .doc(map['id'])
          .set(map);

      return true;
    } catch (err) {
      return false;
    }
  }

  Future<void> updateUserInfo(String username, String mobileNo, String address,
      String registrationDate, String profileImageLink, String about) async {
    return await usersCollection.doc(mobileNo).update({
      'username': username,
      'mobileNo': mobileNo,
      'address': address,
      'registrationDate': registrationDate,
      'profileImageLink': profileImageLink,
      'about': about
    });
  }

  Future<bool> alreadyRegisteredNumber(String mobileNo) async {
    bool exists = false;
    try {
      await usersCollection.doc(mobileNo).get().then((doc) {
        if (doc.exists) {
          exists = true;
        } else {
          exists = false;
        }
      });
      return exists;
    } catch (e) {
      print(
          'Checking mobile number registered or not problem - ${e.toString()}');
      return false;
    }
  }

  Future<bool> checkMobileNoPassword(String mobileNo, String password) async {
    bool matched = false;

    try {
      await usersCollection
          .doc(mobileNo)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          dynamic nested = documentSnapshot.get(FieldPath(['password']));
          if (nested.toString() == password) {
            matched = true;
          } else {
            matched = false;
          }
        } else {
          print('Document does not exist on the database');
        }
      });
      return matched;
    } catch (e) {
      print('Login error - ${e.toString()}');
      return false;
    }
  }

  Future uploadProfileImage(String _currentMobileNo, File _imageFile) async {
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child(_currentMobileNo)
          .putFile(_imageFile);
    } on firebase_core.FirebaseException catch (error) {
      print('Firebase error while uploading profile image - $error');
    }
  }

  Future<String> profileImageDownloadUrl(String _currentMobileNo) async {
    String downloadUrl = await firebase_storage.FirebaseStorage.instance
        .ref('profile_images/$_currentMobileNo')
        .getDownloadURL();

    return downloadUrl;
  }

  Future updatingProfileImageLink(
      String _profileImageLink, String _currentMobileNo) async {
    return await usersCollection.doc(_currentMobileNo).update({
      'profileImageLink': _profileImageLink,
    }).catchError(
        (error) => print('updating profiel image link failed = $error'));
  }

  Future<String> getUserInfo(String _currentMobileNo, String fieldName) async {
    final _snapshot = await usersCollection.doc(_currentMobileNo).get();
    String data = _snapshot[fieldName];
    return data;
  }

  Future<int> getNumberOfComments(String _animalId) async {
    int _numberOfComments = 0;
    try {
      await FirebaseFirestore.instance
          .collection('Animals')
          .doc(_animalId)
          .collection('comments')
          .get()
          .then((snapshot) {
        _numberOfComments = snapshot.docs.length;
      });
      return _numberOfComments;
    } catch (error) {
      print('Number of followers cannot be showed - $error');
      return _numberOfComments;
    }
  }
}
