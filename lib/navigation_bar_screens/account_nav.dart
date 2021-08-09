import 'package:flutter/material.dart';
import 'package:pet_lover/demo_designs/profile_options.dart';
import 'package:pet_lover/provider/animalProvider.dart';
import 'package:pet_lover/provider/userProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountNav extends StatefulWidget {
  @override
  _AccountNavState createState() => _AccountNavState();
}

class _AccountNavState extends State<AccountNav> {
  int _count = 0;
  Map<String, String> _currentUserInfoMap = {};
  String userProfileImage = '';
  String username = '';
  String address = '';
  int _numberOfMyAnimals = 0;
  int _mFollowing = 0;

  _customInit(AnimalProvider animalProvider, UserProvider userProvider) async {
    setState(() {
      _count++;
    });

    await userProvider.getCurrentUserInfo().then((value) {
      _currentUserInfoMap = userProvider.currentUserMap;
      setState(() {
        userProfileImage = _currentUserInfoMap['profileImageLink']!;
        username = _currentUserInfoMap['username']!;
        address = _currentUserInfoMap['address']!;
      });
    });

    await animalProvider.getMyAnimalsNumber().then((value) {
      setState(() {
        _numberOfMyAnimals = animalProvider.numberOfMyAnimals;
      });
    });

    await userProvider.getMyFollowingsNumber().then((value) {
      setState(() {
        _mFollowing = userProvider.mFollowing;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _bodyUI(context),
    );
  }

  Widget _bodyUI(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final AnimalProvider animalProvider = Provider.of<AnimalProvider>(context);
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    if (_count == 0) _customInit(animalProvider, userProvider);
    return SingleChildScrollView(
      child: Container(
        width: size.width,
        child: Padding(
          padding: EdgeInsets.all(size.width * .04),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: size.width * .5,
                    width: size.width * .5,
                    child: CircleAvatar(
                        backgroundColor: Colors.deepOrange,
                        child: CircleAvatar(
                          radius: size.width * .245,
                          backgroundColor: Colors.white,
                          backgroundImage: userProfileImage == ''
                              ? AssetImage('assets/profile_image_demo.png')
                              : NetworkImage(userProfileImage) as ImageProvider,
                        )),
                  ),
                ],
              ),
              SizedBox(height: size.width * .02),
              Text(
                username,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: size.width * .07,
                  fontFamily: 'MateSC',
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: size.width * .1,
                  ),
                  Text(
                    address,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: size.width * .032,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.width * .04,
              ),
              Container(
                  width: size.width,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(size.width * .04,
                        size.width * .01, size.width * .04, size.width * .01),
                    child: Card(
                      color: Colors.white,
                      elevation: size.width * .01,
                      child: Padding(
                        padding: EdgeInsets.all(size.width * .04),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                  _numberOfMyAnimals.toString(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: size.width * .075,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Animals',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: size.width * .032,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  _mFollowing.toString(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: size.width * .075,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Following',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: size.width * .032,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
              SizedBox(
                height: size.width * .07,
              ),
              ProfileOption().showOption(context, 'Add animals'),
              ProfileOption().showOption(context, 'Groups'),
              ProfileOption().showOption(context, 'My animals'),
              ProfileOption().showOption(context, 'Shared animals'),
              ProfileOption().showOption(context, 'My followers')
            ],
          ),
        ),
      ),
    );
  }
}
