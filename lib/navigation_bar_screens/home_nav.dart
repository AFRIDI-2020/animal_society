import 'package:flutter/cupertino.dart';
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
  List<Animal> _list = [];
  List<Animal> _animalLists = [];
  ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _moreAnimalsLoading = false;

  String? finalDate;
  Map<String, String> _currentUserInfoMap = {};

  _customInit(AnimalProvider animalProvider, UserProvider userProvider) async {
    setState(() {
      _isLoading = true;
      _count++;
    });

    await userProvider.getCurrentUserInfo().then((value) {
      setState(() {
        _currentUserInfoMap = userProvider.currentUserMap;
        _isLoading = false;
      });
    });

    if (animalProvider.animalList.isEmpty) {
      setState(() {
        _isLoading = true;
      });

      await animalProvider.getAnimals(2).then((value) {
        setState(() {
          _list = animalProvider.animalList;
          _animalLists = _list;
          print('The animal list first time length = ${_animalLists.length}');
          _isLoading = false;
        });
      });
    } else {
      setState(() {
        _list = animalProvider.animalList;
        _animalLists = _list;
      });
    }

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
    setState(() {
      _moreAnimalsLoading = true;
    });
    await animalProvider.getMoreAnimals(2).then((value) {
      setState(() {
        _list = animalProvider.animalList;
        _animalLists = _list;
        setState(() {
          _moreAnimalsLoading = false;
          print('get more animals $_moreAnimalsLoading');
        });
      });
    });
  }

  Future _onRefresh(
      AnimalProvider animalProvider, UserProvider userProvider) async {
    await animalProvider.getAnimals(2).then((value) {
      setState(() {
        _list = animalProvider.animalList;
        _animalLists = _list;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    AnimalProvider animalProvider =
        Provider.of<AnimalProvider>(context, listen: false);
    animalProvider.getAllChatUser();
  }

  @override
  Widget build(BuildContext context) {
    final AnimalProvider animalProvider = Provider.of<AnimalProvider>(context);
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    Size size = MediaQuery.of(context).size;
    if (_count == 0) _customInit(animalProvider, userProvider);
    return RefreshIndicator(
      onRefresh: () => _onRefresh(animalProvider, userProvider),
      child: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _animalLists.isEmpty
              ? Center(child: Text('Nothing posted yet!'))
              : ListView(
                  controller: _scrollController,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: _animalLists.length,
                      itemBuilder: (context, index) {
                        DateTime miliDate =
                            new DateTime.fromMillisecondsSinceEpoch(
                                int.parse(_animalLists[index].date!));
                        var format = new DateFormat("yMMMd").add_jm();
                        finalDate = format.format(miliDate);

                        return AnimalPost(
                            index: index,
                            profileImageLink:
                                _animalLists[index].userProfileImage!,
                            username: _animalLists[index].username!,
                            mobile: _animalLists[index].mobile!,
                            date: finalDate!,
                            numberOfLoveReacts:
                                _animalLists[index].totalFollowings!,
                            numberOfComments:
                                _animalLists[index].totalComments!,
                            numberOfShares: _animalLists[index].totalShares!,
                            petId: _animalLists[index].id!,
                            petName: _animalLists[index].petName!,
                            petColor: _animalLists[index].color!,
                            petGenus: _animalLists[index].genus!,
                            petGender: _animalLists[index].gender!,
                            petAge: _animalLists[index].age!,
                            petImage: _animalLists[index].photo!,
                            petVideo: _animalLists[index].video!,
                            currentUserImage:
                                _currentUserInfoMap['profileImageLink']!);
                      },
                    ),
                    _moreAnimalsLoading
                        ? Container(
                            height: size.width * .2,
                            child: CupertinoActivityIndicator())
                        : Container()
                  ],
                ),
    );
  }
}
