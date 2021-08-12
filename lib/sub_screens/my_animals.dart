import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:pet_lover/demo_designs/my_animals_demo.dart';
import 'package:pet_lover/model/animal.dart';
import 'package:pet_lover/provider/animalProvider.dart';
import 'package:pet_lover/provider/userProvider.dart';
import 'package:provider/provider.dart';

class MyAnimals extends StatefulWidget {
  @override
  _MyAnimalsState createState() => _MyAnimalsState();
}

class _MyAnimalsState extends State<MyAnimals> {
  List<String> menuItems = ['Edit', 'Delete'];
  int _count = 0;

  String? finalDate;
  Map<String, String> _currentUserInfoMap = {};
  String? _currentMobileNo;
  bool _loading = false;

  _customInit(AnimalProvider animalProvider, UserProvider userProvider) async {
    setState(() {
      _count++;
      _loading = true;
    });

    await userProvider.getCurrentUserInfo().then((value) {
      _currentUserInfoMap = userProvider.currentUserMap;
      _currentMobileNo = _currentUserInfoMap['mobileNo'];
    });

    await animalProvider.getCurrentUserAnimals(_currentMobileNo!).then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final AnimalProvider animalProvider = Provider.of<AnimalProvider>(context);
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    if (_count == 0) _customInit(animalProvider, userProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Animals',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0.0,
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: _loading
            ? Center(child: CircularProgressIndicator())
            : animalProvider.currentUserAnimals.isEmpty
                ? Center(child: Text('You have no animals.'))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: animalProvider.currentUserAnimals.length,
                    itemBuilder: (context, index) {
                      DateTime miliDate =
                          new DateTime.fromMillisecondsSinceEpoch(int.parse(
                              animalProvider.currentUserAnimals[index].date!));
                      var format = new DateFormat("yMMMd").add_jm();
                      finalDate = format.format(miliDate);

                      return MyAnimalsDemo(
                          profileImageLink: animalProvider
                              .currentUserAnimals[index].userProfileImage!,
                          username: animalProvider
                              .currentUserAnimals[index].username!,
                          mobile:
                              animalProvider.currentUserAnimals[index].mobile!,
                          date: finalDate!,
                          numberOfLoveReacts: animalProvider
                              .currentUserAnimals[index].totalFollowings!,
                          numberOfComments: animalProvider
                              .currentUserAnimals[index].totalComments!,
                          numberOfShares: animalProvider
                              .currentUserAnimals[index].totalShares!,
                          petId: animalProvider.currentUserAnimals[index].id!,
                          petName:
                              animalProvider.currentUserAnimals[index].petName!,
                          petColor:
                              animalProvider.currentUserAnimals[index].color!,
                          petGenus:
                              animalProvider.currentUserAnimals[index].genus!,
                          petGender:
                              animalProvider.currentUserAnimals[index].gender!,
                          petAge: animalProvider.currentUserAnimals[index].age!,
                          petImage:
                              animalProvider.currentUserAnimals[index].photo!,
                          petVideo:
                              animalProvider.currentUserAnimals[index].video!,
                          currentUserImage:
                              _currentUserInfoMap['profileImageLink']!);
                    },
                  ),
      ),
    );
  }

  Future<void> _onRefresh() async {}

  Widget _bodyUI(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final AnimalProvider animalProvider = Provider.of<AnimalProvider>(context);
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    if (_count == 0) _customInit(animalProvider, userProvider);
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: _loading
          ? Center(child: CircularProgressIndicator())
          : animalProvider.currentUserAnimals.isEmpty
              ? Center(child: Text('You have no animals.'))
              : ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: animalProvider.currentUserAnimals.length,
                  itemBuilder: (context, index) {
                    DateTime miliDate = new DateTime.fromMillisecondsSinceEpoch(
                        int.parse(
                            animalProvider.currentUserAnimals[index].date!));
                    var format = new DateFormat("yMMMd").add_jm();
                    finalDate = format.format(miliDate);

                    return MyAnimalsDemo(
                        profileImageLink: animalProvider
                            .currentUserAnimals[index].userProfileImage!,
                        username:
                            animalProvider.currentUserAnimals[index].username!,
                        mobile:
                            animalProvider.currentUserAnimals[index].mobile!,
                        date: finalDate!,
                        numberOfLoveReacts: animalProvider
                            .currentUserAnimals[index].totalFollowings!,
                        numberOfComments: animalProvider
                            .currentUserAnimals[index].totalComments!,
                        numberOfShares: animalProvider
                            .currentUserAnimals[index].totalShares!,
                        petId: animalProvider.currentUserAnimals[index].id!,
                        petName:
                            animalProvider.currentUserAnimals[index].petName!,
                        petColor:
                            animalProvider.currentUserAnimals[index].color!,
                        petGenus:
                            animalProvider.currentUserAnimals[index].genus!,
                        petGender:
                            animalProvider.currentUserAnimals[index].gender!,
                        petAge: animalProvider.currentUserAnimals[index].age!,
                        petImage:
                            animalProvider.currentUserAnimals[index].photo!,
                        petVideo:
                            animalProvider.currentUserAnimals[index].video!,
                        currentUserImage:
                            _currentUserInfoMap['profileImageLink']!);
                  },
                ),
    );
  }
}
