import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pet_lover/demo_designs/animal_post.dart';
import 'package:pet_lover/model/animal.dart';
import 'package:pet_lover/provider/animalProvider.dart';
import 'package:pet_lover/provider/userProvider.dart';
import 'package:provider/provider.dart';

class FollowingNav extends StatefulWidget {
  @override
  _FollowingNavState createState() => _FollowingNavState();
}

class _FollowingNavState extends State<FollowingNav> {
  int count = 0;
  List<Animal> _favouriteList = [];
  String? finalDate;
  Map<String, String> _currentUserInfoMap = {};
  String? _currentMobileNo;

  Future _customInit(
      AnimalProvider animalProvider, UserProvider userProvider) async {
    await userProvider.getCurrentUserInfo().then((value) {
      _currentUserInfoMap = userProvider.currentUserMap;
      _currentMobileNo = _currentUserInfoMap['mobileNo'];
    });
    _getFavourites(animalProvider);
    setState(() {
      count++;
    });
  }

  _getFavourites(AnimalProvider animalProvider) async {
    await animalProvider.getFavourites().then((value) {
      _favouriteList = animalProvider.favouriteList;
      print('favourite list length = ${_favouriteList.length}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyUI(context),
    );
  }

  Widget _bodyUI(BuildContext context) {
    final AnimalProvider animalProvider = Provider.of<AnimalProvider>(context);
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    if (count == 0) _customInit(animalProvider, userProvider);
    return _favouriteList.length == 0
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: _favouriteList.length,
            itemBuilder: (context, index) {
              DateTime miliDate = new DateTime.fromMillisecondsSinceEpoch(
                  int.parse(_favouriteList[index].date!));
              var format = new DateFormat("yMMMd").add_jm();
              finalDate = format.format(miliDate);

              return AnimalPost(
                  profileImageLink: _favouriteList[index].userProfileImage!,
                  username: _favouriteList[index].username!,
                  mobile: _favouriteList[index].mobile!,
                  date: finalDate!,
                  numberOfLoveReacts: _favouriteList[index].totalFollowings!,
                  numberOfComments: _favouriteList[index].totalComments!,
                  numberOfShares: _favouriteList[index].totalShares!,
                  petId: _favouriteList[index].id!,
                  petName: _favouriteList[index].petName!,
                  petColor: _favouriteList[index].color!,
                  petGenus: _favouriteList[index].genus!,
                  petGender: _favouriteList[index].gender!,
                  petAge: _favouriteList[index].age!,
                  petImage: _favouriteList[index].photo!,
                  petVideo: _favouriteList[index].video!,
                  currentUserImage: _currentUserInfoMap['profileImageLink']!);
            });
  }
}
