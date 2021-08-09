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
  List<Animal> _animalLists = [];
  String? finalDate;
  Map<String, String> _currentUserInfoMap = {};
  String? _currentMobileNo;

  _customInit(AnimalProvider animalProvider, UserProvider userProvider) async {
    setState(() {
      _count++;
    });

    await userProvider.getCurrentUserInfo().then((value) {
      _currentUserInfoMap = userProvider.currentUserMap;
      _currentMobileNo = _currentUserInfoMap['mobileNo'];
    });

    await animalProvider.getCurrentUserAnimals(_currentMobileNo!).then((value) {
      setState(() {
        _animalLists = animalProvider.currentUserAnimals;
        print(
            'function _customInit() running and getting animals on homepage\nthe top animal ${_animalLists[0].petName}\nlast animal it gets ${_animalLists[_animalLists.length - 1].petName}');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
      body: _bodyUI(context),
    );
  }

  Future<void> _onRefresh() async {
    setState(() {
      _count = 0;
    });
  }

  Widget _bodyUI(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final AnimalProvider animalProvider = Provider.of<AnimalProvider>(context);
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    if (_count == 0) _customInit(animalProvider, userProvider);
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: _animalLists.length,
        itemBuilder: (context, index) {
          DateTime miliDate = new DateTime.fromMillisecondsSinceEpoch(
              int.parse(_animalLists[index].date!));
          var format = new DateFormat("yMMMd").add_jm();
          finalDate = format.format(miliDate);

          return MyAnimalsDemo(
              profileImageLink: _animalLists[index].userProfileImage!,
              username: _animalLists[index].username!,
              mobile: _animalLists[index].mobile!,
              date: finalDate!,
              numberOfLoveReacts: _animalLists[index].totalFollowings!,
              numberOfComments: _animalLists[index].totalComments!,
              numberOfShares: _animalLists[index].totalShares!,
              petId: _animalLists[index].id!,
              petName: _animalLists[index].petName!,
              petColor: _animalLists[index].color!,
              petGenus: _animalLists[index].genus!,
              petGender: _animalLists[index].gender!,
              petAge: _animalLists[index].age!,
              petImage: _animalLists[index].photo!,
              petVideo: _animalLists[index].video!,
              currentUserImage: _currentUserInfoMap['profileImageLink']!);
        },
      ),
    );
  }
}
