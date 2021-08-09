import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pet_lover/demo_designs/animal_post.dart';
import 'package:pet_lover/model/animal.dart';
import 'package:pet_lover/provider/animalProvider.dart';
import 'package:pet_lover/provider/userProvider.dart';
import 'package:provider/provider.dart';

class HomeNav extends StatefulWidget {
  @override
  _HomeNavState createState() => _HomeNavState();
}

class _HomeNavState extends State<HomeNav> {
  int _count = 0;
  List<Animal> _lists = [];
  List<Animal> _animalLists = [];
  ScrollController _scrollController = ScrollController();

  String? finalDate;
  Map<String, String> _currentUserInfoMap = {};

  _customInit(AnimalProvider animalProvider, UserProvider userProvider) async {
    setState(() {
      _count++;
    });
    _animalLists.clear();
    await userProvider.getCurrentUserInfo().then((value) {
      _currentUserInfoMap = userProvider.currentUserMap;
    });

    await animalProvider.getAnimals(3).then((value) {
      setState(() {
        _lists = animalProvider.animalList;
        _animalLists = _lists;
        print('The animal list first time length = ${_animalLists.length}');
      });
    });

    _scrollController.addListener(() {
      if (_scrollController.offset >=
          _scrollController.position.maxScrollExtent) {
        print('scrolling max and getting more animals');
        _getMoreAnimals(animalProvider);
        print('The animal list length = ${_animalLists.length}');
      }
    });
  }

  _getMoreAnimals(AnimalProvider animalProvider) async {
    await animalProvider.getMoreAnimals(3).then((value) {
      setState(() {
        _lists = animalProvider.animalList;
        _animalLists = _lists;
      });
    });
  }

  Future _onRefresh(
      AnimalProvider animalProvider, UserProvider userProvider) async {
    await animalProvider.getAnimals(3).then((value) {
      setState(() {
        _lists = animalProvider.animalList;

        _animalLists = _lists;
        print('The animal list first time length = ${_animalLists.length}');
        print(
            'function _customInit() running and getting animals on homepage\nthe top animal ${_animalLists[0].petName}\nlast animal it gets ${_animalLists[_animalLists.length - 1].petName}');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final AnimalProvider animalProvider = Provider.of<AnimalProvider>(context);
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    if (_count == 0) _customInit(animalProvider, userProvider);

    return RefreshIndicator(
      onRefresh: () => _onRefresh(animalProvider, userProvider),
      child: _animalLists.length == 0
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              controller: _scrollController,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: _animalLists.length,
              itemBuilder: (context, index) {
                DateTime miliDate = new DateTime.fromMillisecondsSinceEpoch(
                    int.parse(_animalLists[index].date!));
                var format = new DateFormat("yMMMd").add_jm();
                finalDate = format.format(miliDate);

                return AnimalPost(
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
