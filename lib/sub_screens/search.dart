import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pet_lover/demo_designs/animal_post.dart';
import 'package:pet_lover/demo_designs/search_bar.dart';
import 'package:pet_lover/model/animal.dart';
import 'package:pet_lover/provider/animalProvider.dart';
import 'package:pet_lover/provider/userProvider.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  List<Animal> _allAnimalList = [];
  List<Animal> _searchedList = [];
  int _count = 0;
  String? finalDate;
  Map<String, String> _currentUserInfoMap = {};

  Future _customInit(
      AnimalProvider animalProvider, UserProvider userProvider) async {
    _count++;
    await userProvider.getCurrentUserInfo().then((value) {
      _currentUserInfoMap = userProvider.currentUserMap;
    });
    _allAnimals(animalProvider);
  }

  _allAnimals(AnimalProvider animalProvider) async {
    await animalProvider.searchAnimals().then((value) {
      setState(() {
        _allAnimalList = animalProvider.searchedAnimals;
      });
    });
  }

  _searchAnimals(String searchItem) {
    setState(() {
      if (searchItem == '') {
        searchItem = 'abcdef';
      }
      _searchedList = _allAnimalList
          .where((element) => (element.petName!
              .toLowerCase()
              .contains(searchItem.toLowerCase())))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final AnimalProvider animalProvider = Provider.of<AnimalProvider>(context);
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    if (_count == 0) _customInit(animalProvider, userProvider);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            'Search Animals',
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
        body: _bodyUI(context));
  }

  Widget _bodyUI(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        width: size.width,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          searchAnimalsField(context),
          SizedBox(
            height: size.width * .03,
          ),
          Expanded(
            child: Container(
              width: size.width,
              child: _searchedList.isEmpty
                  ? Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                        ],
                      ),
                    )
                  : ListView.builder(
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _searchedList.length,
                      itemBuilder: (context, index) {
                        DateTime miliDate =
                            new DateTime.fromMillisecondsSinceEpoch(
                                int.parse(_searchedList[index].date!));
                        var format = new DateFormat("yMMMd").add_jm();
                        finalDate = format.format(miliDate);

                        return AnimalPost(
                            index: index,
                            profileImageLink:
                                _searchedList[index].userProfileImage!,
                            username: _searchedList[index].username!,
                            mobile: _searchedList[index].mobile!,
                            date: finalDate!,
                            numberOfLoveReacts:
                                _searchedList[index].totalFollowings!,
                            numberOfComments:
                                _searchedList[index].totalComments!,
                            numberOfShares: _searchedList[index].totalShares!,
                            petId: _searchedList[index].id!,
                            petName: _searchedList[index].petName!,
                            petColor: _searchedList[index].color!,
                            petGenus: _searchedList[index].genus!,
                            petGender: _searchedList[index].gender!,
                            petAge: _searchedList[index].age!,
                            petImage: _searchedList[index].photo!,
                            petVideo: _searchedList[index].video!,
                            currentUserImage:
                                _currentUserInfoMap['profileImageLink']!);
                      }),
            ),
          ),
        ]));
  }

  Widget searchAnimalsField(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.fromLTRB(size.width * .04, size.width * .04,
          size.width * .04, size.width * .02),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(size.width * .05),
                color: Colors.grey[300],
              ),
              padding: EdgeInsets.fromLTRB(
                  0, size.width * .02, size.width * .02, size.width * .02),
              child: TextFormField(
                onChanged: _searchAnimals,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  hintText: 'Pet name',
                  hintStyle: TextStyle(color: Colors.black),
                  isDense: true,
                  contentPadding: EdgeInsets.only(left: size.width * .04),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
