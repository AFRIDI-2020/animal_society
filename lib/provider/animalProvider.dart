import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:pet_lover/model/Comment.dart';
import 'package:pet_lover/model/animal.dart';
import 'package:pet_lover/model/chat_user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnimalProvider extends ChangeNotifier {
  List<Animal> _animalList = [];
  bool _isFollower = false;
  int _numberOfFollowers = 0;
  int _numberOfComments = 0;
  int _numberOfShares = 0;
  List<Comment> _commentList = [];
  int documentLimit = 4;
  DocumentSnapshot? _startAfter;
  int _numberOfMyAnimals = 0;
  List<Animal> _currentUserAnimals = [];
  List<Animal> _otherUserAnimals = [];
  List<Animal> _userSharedAnimals = [];
  List<Animal> _favouriteList = [];
  int _userAnimalNumber = 0;
  int _userFollowersNumber = 0;
  List<Animal> _searchedAnimals = [];
  List<ChatUserModel> _chatUserList = <ChatUserModel>[];

  get numberOfFollowers => _numberOfFollowers;
  get favouriteList => _favouriteList;
  get animalList => _animalList;
  get isFollower => _isFollower;
  get commentList => _commentList;
  get numberOfComments => _numberOfComments;
  get numberOfMyAnimals => _numberOfMyAnimals;
  get numberOfShares => _numberOfShares;
  get currentUserAnimals => _currentUserAnimals;
  get otheUserAnimals => _otherUserAnimals;
  get userAnimalNumber => _userAnimalNumber;
  get userFollowersNumber => _userFollowersNumber;
  get userSharedAnimals => _userSharedAnimals;
  get searchedAnimals => _searchedAnimals;
  get chatUserList => _chatUserList;

  Future<List<Animal>> getAnimals(int limit) async {
    print('getAnimals() running');
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Animals')
          .orderBy('date', descending: true)
          .limit(limit)
          .get();

      _animalList.clear();
      if (querySnapshot.docs.isNotEmpty) {
        _startAfter = querySnapshot.docs.last;
        print('the _startAfter value ${_startAfter!.data()}');
      } else {
        _startAfter = null;
      }

      querySnapshot.docChanges.forEach((element) {
        Animal animal = Animal(
          userProfileImage: element.doc['userProfileImage'],
          username: element.doc['username'],
          mobile: element.doc['mobile'],
          age: element.doc['age'],
          color: element.doc['color'],
          date: element.doc['date'],
          gender: element.doc['gender'],
          genus: element.doc['genus'],
          id: element.doc['id'],
          petName: element.doc['petName'],
          photo: element.doc['photo'],
          totalComments: element.doc['totalComments'],
          totalFollowings: element.doc['totalFollowings'],
          totalShares: element.doc['totalShares'],
          video: element.doc['video'],
        );
        _animalList.add(animal);
        notifyListeners();
      });
      return animalList;
    } catch (error) {
      print('Error: $error');
      return [];
    }
  }

  Future<List<Animal>> getMoreAnimals(int limit) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Animals')
          .orderBy('date', descending: true)
          .limit(limit)
          .startAfterDocument(_startAfter!)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        _startAfter = querySnapshot.docs.last;
        print('after scrolling last animal ${_startAfter!.data()}');
      } else {
        _startAfter = null;
      }

      querySnapshot.docChanges.forEach((element) {
        Animal animal = Animal(
          userProfileImage: element.doc['userProfileImage'],
          username: element.doc['username'],
          mobile: element.doc['mobile'],
          age: element.doc['age'],
          color: element.doc['color'],
          date: element.doc['date'],
          gender: element.doc['gender'],
          genus: element.doc['genus'],
          id: element.doc['id'],
          petName: element.doc['petName'],
          photo: element.doc['photo'],
          totalComments: element.doc['totalComments'],
          totalFollowings: element.doc['totalFollowings'],
          totalShares: element.doc['totalShares'],
          video: element.doc['video'],
        );
        _animalList.add(animal);
      });
      return animalList;
    } catch (error) {
      print('Error: $error');
      return [];
    }
  }

  Future<void> getNumberOfFollowers(String _animalId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Animals')
          .doc(_animalId)
          .collection('followers')
          .get()
          .then((snapshot) {
        _numberOfFollowers = snapshot.docs.length;
      });
    } catch (error) {
      print('Number of followers cannot be showed - $error');
    }
  }

  Future<void> getUserSharedAnimals(String userMobileNo) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userMobileNo)
          .collection('shared_animals')
          .orderBy('date', descending: true)
          .get()
          .then((snapshot) {
        _userSharedAnimals.clear();
        snapshot.docChanges.forEach((element) async {
          bool exists = await animalExistsOrNot(element.doc['id']);
          if (exists == true) {
            Animal animal = Animal(
              userProfileImage: element.doc['userProfileImage'],
              username: element.doc['username'],
              mobile: element.doc['mobile'],
              age: element.doc['age'],
              color: element.doc['color'],
              date: element.doc['date'],
              gender: element.doc['gender'],
              genus: element.doc['genus'],
              id: element.doc['id'],
              petName: element.doc['petName'],
              photo: element.doc['photo'],
              totalComments: element.doc['totalComments'],
              totalFollowings: element.doc['totalFollowings'],
              totalShares: element.doc['totalShares'],
              video: element.doc['video'],
            );
            _userSharedAnimals.add(animal);
            notifyListeners();
          }
        });
      });
    } catch (error) {
      print('getting user shared animals error - $error');
    }
  }

  Future<bool> animalExistsOrNot(String animalId) async {
    bool isExists = false;

    await FirebaseFirestore.instance
        .collection('Animals')
        .doc(animalId)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        isExists = true;
      } else {
        isExists = false;
      }
    });

    return isExists;
  }

  Future<void> getNumberOfComments(String _animalId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Animals')
          .doc(_animalId)
          .collection('comments')
          .get()
          .then((snapshot) {
        _numberOfComments = snapshot.docs.length;
        notifyListeners();
      });
    } catch (error) {
      print('Number of followers cannot be showed - $error');
    }
  }

  Future<void> getNumberOfShares(String _animalId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Animals')
          .doc(_animalId)
          .collection('sharingPersons')
          .get()
          .then((snapshot) {
        _numberOfShares = snapshot.docs.length;
      });
    } catch (error) {
      print('Number of shares cannot be showed - $error');
    }
  }

  Future<void> isFollowerOrNot(
      String _animalId, String _currentMobileNo) async {
    try {
      await FirebaseFirestore.instance
          .collection('Animals')
          .doc(_animalId)
          .collection('followers')
          .doc(_currentMobileNo)
          .get()
          .then((snapshot) {
        if (snapshot.exists) {
          _isFollower = true;
        } else {
          _isFollower = false;
        }
      });
    } catch (error) {
      print('is follower? - $error');
    }
  }

  Future<void> addFollowers(
      String _animalId, String _currentMobileNo, String _username) async {
    Map<String, String> followers = {'username': _username};

    try {
      await FirebaseFirestore.instance
          .collection('Animals')
          .doc(_animalId)
          .collection('followers')
          .doc(_currentMobileNo)
          .set(followers);
    } catch (error) {
      print('Adding followers error = $error');
    }
  }

  Future<void> myFollowings(
      String _currentMobileNo,
      String mobileNo,
      String followingName,
      String followerName,
      String followingImage,
      String followerImage) async {
    try {
      if (mobileNo != _currentMobileNo) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_currentMobileNo)
            .collection('myFollowings')
            .doc(mobileNo)
            .set({'username': followingName, 'mobile': mobileNo});

        await FirebaseFirestore.instance
            .collection('users')
            .doc(mobileNo)
            .collection('followers')
            .doc(_currentMobileNo)
            .set({
          'follower': _currentMobileNo,
        }).then((value) async {
          await FirebaseFirestore.instance
              .collection('chatUsers')
              .doc(_currentMobileNo + mobileNo)
              .set({
            'id': _currentMobileNo,
            'followingName': followingName,
            'followerName': followerName,
            'followingImageLink': followingImage,
            'followerImageLink': followerImage,
            'followerNumber': _currentMobileNo,
            'followingNumber': mobileNo,
            'lastMessage': 'You can now chat with this animal owner',
            'lastMessageTime': Timestamp.now(),
            'isSeen': false
          }).then((value) async {
            await getAllChatUser();
          });
        });
      }
    } catch (error) {
      print('Cannot add in followings ... error = $error');
    }
  }

  Future<void> updateSeen(
      String followerMobileNo, String followingMobileNo) async {
    final refUsers3 = FirebaseFirestore.instance.collection('chatUsers');
    await refUsers3
        .doc(followerMobileNo + followingMobileNo)
        .update({'isSeen': true});
  }

  Future<void> uploadMessage(
      String message,
      String senderName,
      String senderMobile,
      String followerNumber,
      String followingNumber,
      String followingName,
      String followerName) async {
    final refMessages1 = FirebaseFirestore.instance
        .collection('Chats/$followerNumber $followingNumber/messages');
    final refUsers = FirebaseFirestore.instance.collection('chatUsers');

    await refMessages1.add({
      'text': message,
      'sender': senderMobile,
      'senderName': senderName,
      'follower': followerName,
      'following': followingName,
      "timestamp": Timestamp.now(),
    }).then((value) async {
      await refUsers.doc(followerNumber + followingNumber).update({
        'id': followerNumber,
        'followingName': followingName,
        'followerName': followerName,
        'followerNumber': followerNumber,
        'followingNumber': followingNumber,
        'lastMessage': message,
        'lastMessageTime': Timestamp.now(),
        'isSeen': false
      });
    });
    notifyListeners();
  }

  Future<void> getAllChatUser() async {
    try {
      await FirebaseFirestore.instance
          .collection('chatUsers')
          .orderBy('lastMessageTime', descending: true)
          .get()
          .then((snapShot) {
        _chatUserList.clear();
        snapShot.docChanges.forEach((element) {
          ChatUserModel chatUsers = ChatUserModel(
              id: element.doc['id'],
              followingName: element.doc['followingName'],
              followerName: element.doc['followerName'],
              followingImageLink: element.doc['followingImageLink'],
              followerImageLink: element.doc['followerImageLink'],
              followerNumber: element.doc['followerNumber'],
              followingNumber: element.doc['followingNumber'],
              lastMessage: element.doc['lastMessage'],
              lastMessageTime: element.doc['lastMessageTime'],
              isSeen: element.doc['isSeen']);
          _chatUserList.add(chatUsers);
        });
        return _chatUserList;
      });
      notifyListeners();
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> deleteChat(String followingNumber, String followerNumber) async {
    await FirebaseFirestore.instance
        .collection('chatUsers')
        .doc(followerNumber + followingNumber)
        .delete()
        .then((value) async {
      await getAllChatUser();
    });
  }

  Future<void> removeMyFollowings(String currentMobileNo, String mobile) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentMobileNo)
          .collection('myFollowings')
          .doc(mobile)
          .delete();
      print('deleted object: $mobile');
    } catch (error) {
      print(
          'Cannot delete $mobile from myFollowings of $currentMobileNo = $error');
    }
  }

  Future<void> removeFollower(String _animalId, String _currentMobileNo) async {
    try {
      await FirebaseFirestore.instance
          .collection('Animals')
          .doc(_animalId)
          .collection('followers')
          .doc(_currentMobileNo)
          .delete();
    } catch (error) {
      print('Cannot delete follower - $error');
    }
  }

  Future<void> addComment(
      String petId,
      String commentId,
      String comment,
      String animalOwnerMobileNo,
      String currentUserMobileNo,
      String date,
      String totalLikes) async {
    try {
      await FirebaseFirestore.instance
          .collection('Animals')
          .doc(petId)
          .collection('comments')
          .doc(commentId)
          .set({
        'commentId': commentId,
        'comment': comment,
        'date': date,
        'animalOwnerMobileNo': animalOwnerMobileNo,
        'commenter': currentUserMobileNo,
        'totalLikes': totalLikes
      });
    } catch (error) {
      print('Add comment failed: $error');
    }
  }

  Future<void> getCurrentUserAnimals(String _currentMobileNo) async {
    print('getCurrentUserAnimals() running');
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentMobileNo)
          .collection('my_pets')
          .orderBy('date', descending: true)
          .get();

      _currentUserAnimals.clear();
      querySnapshot.docChanges.forEach((element) {
        Animal animal = Animal(
          userProfileImage: element.doc['userProfileImage'],
          username: element.doc['username'],
          mobile: element.doc['mobile'],
          age: element.doc['age'],
          color: element.doc['color'],
          date: element.doc['date'],
          gender: element.doc['gender'],
          genus: element.doc['genus'],
          id: element.doc['id'],
          petName: element.doc['petName'],
          photo: element.doc['photo'],
          totalComments: element.doc['totalComments'],
          totalFollowings: element.doc['totalFollowings'],
          totalShares: element.doc['totalShares'],
          video: element.doc['video'],
        );
        _currentUserAnimals.add(animal);
        notifyListeners();
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> getOtherUserAnimals(String mobileNo) async {
    print('getCurrentUserAnimals() running');
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(mobileNo)
          .collection('my_pets')
          .orderBy('date', descending: true)
          .get();

      _otherUserAnimals.clear();
      querySnapshot.docChanges.forEach((element) {
        Animal animal = Animal(
          userProfileImage: element.doc['userProfileImage'],
          username: element.doc['username'],
          mobile: element.doc['mobile'],
          age: element.doc['age'],
          color: element.doc['color'],
          date: element.doc['date'],
          gender: element.doc['gender'],
          genus: element.doc['genus'],
          id: element.doc['id'],
          petName: element.doc['petName'],
          photo: element.doc['photo'],
          totalComments: element.doc['totalComments'],
          totalFollowings: element.doc['totalFollowings'],
          totalShares: element.doc['totalShares'],
          video: element.doc['video'],
        );
        _otherUserAnimals.add(animal);
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<String> _getCurrentMobileNo() async {
    final _prefs = await SharedPreferences.getInstance();
    final _currentMobileNo = _prefs.getString('mobileNo') ?? null;
    print('Current Mobile no given by userProvider is $_currentMobileNo');
    return _currentMobileNo!;
  }

  Future<void> getMyAnimalsNumber() async {
    String? _currentMobileNo = await _getCurrentMobileNo();
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_currentMobileNo)
        .collection('my_pets')
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      _numberOfMyAnimals = querySnapshot.docs.length;
    }
  }

  Future<void> getUserAnimalsNumber(String mobileNo) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(mobileNo)
        .collection('my_pets')
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      _userAnimalNumber = querySnapshot.docs.length;
    }
  }

  Future<void> getUserFollowersNumber(String mobileNo) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(mobileNo)
        .collection('followers')
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      _userFollowersNumber = querySnapshot.docs.length;
    }
  }

  Future shareAnimal(String petId) async {
    String date = DateTime.now().millisecondsSinceEpoch.toString();
    String? _currentMobileNo = await _getCurrentMobileNo();
    Animal _animal = await getSpecificAnimal(petId);
    DocumentReference sharedAnimalRef = FirebaseFirestore.instance
        .collection('users')
        .doc(_currentMobileNo)
        .collection('shared_animals')
        .doc(petId);

    DocumentReference sharingPersonsRef = FirebaseFirestore.instance
        .collection('Animals')
        .doc(petId)
        .collection('sharingPersons')
        .doc(_currentMobileNo);

    sharedAnimalRef.get().then((snapshot) async {
      if (!snapshot.exists) {
        await sharedAnimalRef.set({
          'userProfileImage': _animal.userProfileImage,
          'username': _animal.username,
          'mobile': _animal.mobile,
          'age': _animal.age,
          'color': _animal.color,
          'date': _animal.date,
          'gender': _animal.gender,
          'genus': _animal.genus,
          'id': _animal.id,
          'petName': _animal.petName,
          'photo': _animal.photo,
          'totalComments': _animal.totalComments,
          'totalFollowings': _animal.totalFollowings,
          'totalShares': _animal.totalShares,
          'video': _animal.video
        });

        await sharingPersonsRef.set({
          'date': date,
        });
      }
    });
  }

  Future<Animal> getSpecificAnimal(String petId) async {
    DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection('Animals').doc(petId).get();

    Animal animal = Animal(
      userProfileImage: documentSnapshot['userProfileImage'],
      username: documentSnapshot['username'],
      mobile: documentSnapshot['mobile'],
      age: documentSnapshot['age'],
      color: documentSnapshot['color'],
      date: documentSnapshot['date'],
      gender: documentSnapshot['gender'],
      genus: documentSnapshot['genus'],
      id: documentSnapshot['id'],
      petName: documentSnapshot['petName'],
      photo: documentSnapshot['photo'],
      totalComments: documentSnapshot['totalComments'],
      totalFollowings: documentSnapshot['totalFollowings'],
      totalShares: documentSnapshot['totalShares'],
      video: documentSnapshot['video'],
    );

    return animal;
  }

  Future<void> deleteAnimal(String petId, String petImage) async {
    try {
      if (petImage != '') {
        Reference storageRef = FirebaseStorage.instance.refFromURL(petImage);
        await storageRef.delete();
      }

      String currentMobileNo = await _getCurrentMobileNo();
      DocumentReference animalRef =
          FirebaseFirestore.instance.collection('Animals').doc(petId);

      DocumentReference myAnimalRef = FirebaseFirestore.instance
          .collection('users')
          .doc(currentMobileNo)
          .collection('my_pets')
          .doc(petId);

      await animalRef.get().then((snapshot) {
        if (snapshot.exists) {
          animalRef.collection('followers').get().then((snapshot) {
            for (DocumentSnapshot ds in snapshot.docs) {
              ds.reference.delete();
            }
          });

          animalRef.collection('comments').get().then((snapshot) {
            for (DocumentSnapshot ds in snapshot.docs) {
              ds.reference.delete();
            }
          });

          animalRef.collection('sharingPersons').get().then((snapshot) {
            for (DocumentSnapshot ds in snapshot.docs) {
              ds.reference.delete();
            }
          });

          animalRef.delete();
        }
      });

      await myAnimalRef.get().then((snapshot) {
        if (snapshot.exists) {
          myAnimalRef.delete();
        }
      });
      notifyListeners();

      print('deleted animal $petId}');
    } catch (error) {
      print('Deleting animal failed - $error');
    }
  }

  Future<void> getFavourites() async {
    try {
      print('getFavourite running');
      _favouriteList.clear();
      String currentMobileNo = await _getCurrentMobileNo();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentMobileNo)
          .collection('myFollowings')
          .get()
          .then((snapshot) async {
        snapshot.docChanges.forEach((element) async {
          String favouriteUser = element.doc['mobile'];
          print('favourite users animal taking');
          await FirebaseFirestore.instance
              .collection('Animals')
              .where('mobile', isEqualTo: favouriteUser)
              .get()
              .then((value) {
            value.docChanges.forEach((element) {
              Animal animal = Animal(
                userProfileImage: element.doc['userProfileImage'],
                username: element.doc['username'],
                mobile: element.doc['mobile'],
                age: element.doc['age'],
                color: element.doc['color'],
                date: element.doc['date'],
                gender: element.doc['gender'],
                genus: element.doc['genus'],
                id: element.doc['id'],
                petName: element.doc['petName'],
                photo: element.doc['photo'],
                totalComments: element.doc['totalComments'],
                totalFollowings: element.doc['totalFollowings'],
                totalShares: element.doc['totalShares'],
                video: element.doc['video'],
              );
              _favouriteList.add(animal);
              notifyListeners();
            });
          });
        });
      });
    } catch (error) {
      print('Getting favourites error - $error');
    }
  }

  Future<bool> addGroupPost(Map<String, String> map, String groupId) async {
    try {
      String _currentMobileNo = await _getCurrentMobileNo();
      await FirebaseFirestore.instance
          .collection("groupPosts")
          .doc(map['id'])
          .set(map);

      await FirebaseFirestore.instance
          .collection('Groups')
          .doc(groupId)
          .collection('posts')
          .doc(map['id'])
          .set(map);

      return true;
    } catch (err) {
      return false;
    }
  }

  Future<void> searchAnimals() async {
    try {
      await FirebaseFirestore.instance
          .collection('Animals')
          .get()
          .then((snapshot) {
        _searchedAnimals.clear();
        snapshot.docChanges.forEach((element) {
          Animal animal = Animal(
            userProfileImage: element.doc['userProfileImage'],
            username: element.doc['username'],
            mobile: element.doc['mobile'],
            age: element.doc['age'],
            color: element.doc['color'],
            date: element.doc['date'],
            gender: element.doc['gender'],
            genus: element.doc['genus'],
            id: element.doc['id'],
            petName: element.doc['petName'],
            photo: element.doc['photo'],
            totalComments: element.doc['totalComments'],
            totalFollowings: element.doc['totalFollowings'],
            totalShares: element.doc['totalShares'],
            video: element.doc['video'],
          );
          _searchedAnimals.add(animal);
          notifyListeners();
        });
      });
    } catch (error) {
      print('Searching animal failed, error: $error');
    }
  }
}
