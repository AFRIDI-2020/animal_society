import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pet_lover/demo_designs/animal_post.dart';
import 'package:pet_lover/model/animal.dart';
import 'package:pet_lover/provider/animalProvider.dart';
import 'package:pet_lover/provider/userProvider.dart';
import 'package:provider/provider.dart';

class UserSharedAnimals extends StatefulWidget {
  String userMobileNo;
  String username;
  UserSharedAnimals(
      {Key? key, required this.userMobileNo, required this.username})
      : super(key: key);

  @override
  _UserSharedAnimalsState createState() =>
      _UserSharedAnimalsState(userMobileNo, username);
}

class _UserSharedAnimalsState extends State<UserSharedAnimals> {
  String userMobileNo;
  String username;
  _UserSharedAnimalsState(this.userMobileNo, this.username);
  int _count = 0;
  List<Animal> _sharedAnimalList = [];
  Map<String, String> _currentUserInfoMap = {};
  String? finalDate;

  Future _customInit(
      AnimalProvider animalProvider, UserProvider userProvider) async {
    setState(() {
      _count++;
    });

    await userProvider.getCurrentUserInfo().then((value) {
      _currentUserInfoMap = userProvider.currentUserMap;
    });

    await animalProvider.getUserSharedAnimals(userMobileNo).then((value) {
      setState(() {
        _sharedAnimalList = animalProvider.userSharedAnimals;
        print('sharedAnimalList length = ${_sharedAnimalList.length}');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Shared Animals',
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

  Widget _bodyUI(BuildContext context) {
    final AnimalProvider animalProvider = Provider.of<AnimalProvider>(context);
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    if (_count == 0) _customInit(animalProvider, userProvider);
    return _sharedAnimalList.length == 0
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: _sharedAnimalList.length,
            itemBuilder: (context, index) {
              DateTime miliDate = new DateTime.fromMillisecondsSinceEpoch(
                  int.parse(_sharedAnimalList[index].date!));
              var format = new DateFormat("yMMMd").add_jm();
              finalDate = format.format(miliDate);
              return AnimalPost(
                  index: index,
                  profileImageLink: _sharedAnimalList[index].userProfileImage!,
                  username: _sharedAnimalList[index].username!,
                  mobile: _sharedAnimalList[index].mobile!,
                  date: finalDate!,
                  numberOfLoveReacts: _sharedAnimalList[index].totalFollowings!,
                  numberOfComments: _sharedAnimalList[index].totalComments!,
                  numberOfShares: _sharedAnimalList[index].totalShares!,
                  petId: _sharedAnimalList[index].id!,
                  petName: _sharedAnimalList[index].petName!,
                  petColor: _sharedAnimalList[index].color!,
                  petGenus: _sharedAnimalList[index].genus!,
                  petGender: _sharedAnimalList[index].gender!,
                  petAge: _sharedAnimalList[index].age!,
                  petImage: _sharedAnimalList[index].photo!,
                  petVideo: _sharedAnimalList[index].video!,
                  currentUserImage: _currentUserInfoMap['profileImageLink']!);
            });
  }
}
