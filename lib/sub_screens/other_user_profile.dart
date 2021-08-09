import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pet_lover/provider/animalProvider.dart';
import 'package:pet_lover/provider/userProvider.dart';
import 'package:pet_lover/sub_screens/userFollowers.dart';
import 'package:pet_lover/sub_screens/userFollowing.dart';
import 'package:pet_lover/sub_screens/users_animals.dart';
import 'package:pet_lover/sub_screens/users_shared_animals.dart';
import 'package:provider/provider.dart';

class OtherUserProfile extends StatefulWidget {
  String userMobileNo;
  String username;
  OtherUserProfile(
      {Key? key, required this.userMobileNo, required this.username})
      : super(key: key);

  @override
  _OtherUserProfileState createState() =>
      _OtherUserProfileState(userMobileNo, username);
}

class _OtherUserProfileState extends State<OtherUserProfile> {
  String userMobileNo;
  String username;
  _OtherUserProfileState(this.userMobileNo, this.username);
  Map<String, String> _userInfo = {};
  int count = 0;
  int _numberOfAnimals = 0;
  String _address = '';
  String _profileImageLink = '';
  int _numberOfFollowers = 0;

  Future _customInit(
      UserProvider userProvider, AnimalProvider animalProvider) async {
    _getUserInfo(userProvider, userMobileNo);
    _getNumberOfAnimals(animalProvider);
    _getNumberOfFollowers(animalProvider);
    setState(() {
      count++;
    });
  }

  _getUserInfo(UserProvider userProvider, String userMobileNo) async {
    await userProvider.getSpecificUserInfo(userMobileNo).then((value) {
      setState(() {
        _userInfo = userProvider.specificUserMap;
        _address = _userInfo['address']!;
        _profileImageLink = _userInfo['profileImageLink']!;
      });
    });
  }

  _getNumberOfFollowers(AnimalProvider animalProvider) async {
    await animalProvider.getUserFollowersNumber(userMobileNo).then((value) {
      setState(() {
        _numberOfFollowers = animalProvider.userFollowersNumber;
      });
    });
  }

  _getNumberOfAnimals(AnimalProvider animalProvider) async {
    await animalProvider.getUserAnimalsNumber(userMobileNo).then((value) {
      setState(() {
        _numberOfAnimals = animalProvider.userAnimalNumber;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          username,
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
    Size size = MediaQuery.of(context).size;
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final AnimalProvider animalProvider = Provider.of<AnimalProvider>(context);
    if (count == 0) _customInit(userProvider, animalProvider);
    return SingleChildScrollView(
      child: Container(
        width: size.width,
        padding:
            EdgeInsets.only(left: size.width * .04, right: size.width * .04),
        child: Column(
          children: [
            SizedBox(height: size.width * .05),
            Container(
              width: size.width,
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      height: size.width * .5,
                      width: size.width * .5,
                      child: CircleAvatar(
                          backgroundColor: Colors.deepOrange,
                          child: CircleAvatar(
                              radius: size.width * .245,
                              backgroundColor: Colors.white,
                              backgroundImage: _profileImageLink == ''
                                  ? AssetImage('assets/profile_image_demo.png')
                                  : NetworkImage(_profileImageLink)
                                      as ImageProvider)),
                    ),
                  ),
                  Positioned(
                      right: 10,
                      top: 10,
                      child: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.chat, size: size.width * .06)))
                ],
              ),
            ),
            SizedBox(
              height: size.width * .04,
            ),
            Text(
              username,
              style: TextStyle(
                color: Colors.black,
                fontSize: size.width * .07,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              _address,
              style: TextStyle(
                color: Colors.black,
                fontSize: size.width * .04,
              ),
            ),
            SizedBox(height: size.width * .04),
            Container(
                width: size.width,
                child: Card(
                  color: Colors.white,
                  elevation: size.width * .01,
                  child: Padding(
                    padding: EdgeInsets.all(size.width * .045),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              _numberOfAnimals.toString(),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: size.width * .075,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: size.width * .02),
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
                              _numberOfFollowers.toString(),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: size.width * .075,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: size.width * .02),
                            Text(
                              'Followers',
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
                )),
            SizedBox(height: size.width * .04),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserAnimals(
                            userMobileNo: userMobileNo, username: username)));
              },
              leading: Icon(
                FontAwesomeIcons.paw,
                color: Colors.deepOrange,
              ),
              title: Text(
                'Animals',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: size.width * .04,
                    fontWeight: FontWeight.w600),
              ),
              trailing: Icon(Icons.chevron_right, color: Colors.deepOrange),
            ),
            Container(
              width: size.width,
              child: Divider(
                color: Colors.grey,
                thickness: size.width * .001,
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserSharedAnimals(
                            userMobileNo: userMobileNo, username: username)));
              },
              leading: Icon(
                FontAwesomeIcons.shareAlt,
                color: Colors.deepOrange,
              ),
              title: Text(
                'Shared animals',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: size.width * .04,
                    fontWeight: FontWeight.w600),
              ),
              trailing: Icon(Icons.chevron_right, color: Colors.deepOrange),
            ),
            Container(
              width: size.width,
              child: Divider(
                color: Colors.grey,
                thickness: size.width * .001,
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserFollowers(
                            userMobileNo: userMobileNo, username: username)));
              },
              leading: Icon(
                FontAwesomeIcons.userFriends,
                color: Colors.deepOrange,
              ),
              title: Text(
                'Followers',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: size.width * .04,
                    fontWeight: FontWeight.w600),
              ),
              trailing: Icon(Icons.chevron_right, color: Colors.deepOrange),
            ),
            Container(
              width: size.width,
              child: Divider(
                color: Colors.grey,
                thickness: size.width * .001,
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserFollowing(
                            userMobileNo: userMobileNo, username: username)));
              },
              leading: Icon(
                FontAwesomeIcons.users,
                color: Colors.deepOrange,
              ),
              title: Text(
                'Following',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: size.width * .04,
                    fontWeight: FontWeight.w600),
              ),
              trailing: Icon(Icons.chevron_right, color: Colors.deepOrange),
            ),
          ],
        ),
      ),
    );
  }
}
