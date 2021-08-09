import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pet_lover/navigation_bar_screens/account_nav.dart';
import 'package:pet_lover/navigation_bar_screens/chat_nav.dart';
import 'package:pet_lover/navigation_bar_screens/following_nav.dart';
import 'package:pet_lover/navigation_bar_screens/home_nav.dart';
import 'package:pet_lover/provider/userProvider.dart';
import 'package:pet_lover/sub_screens/search.dart';
import 'package:provider/provider.dart';

import 'demo_designs/profile_options.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final _tabs = [
    HomeNav(),
    FollowingNav(),
    ChatNav(),
    AccountNav(),
  ];

  bool _titleVisibility = true;
  String _appbarTitle = '';

  var _pageController = PageController();

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  Map<String, String> _currentUserInfo = {};
  int _count = 0;
  String _userProfileImage = '';
  String _username = '';
  String _finalUsername = '';
  String _mobileNo = '';

  _customInit(UserProvider userProvider) async {
    setState(() {
      _count++;
    });
    await userProvider.getCurrentUserInfo().then((value) {
      setState(() {
        _currentUserInfo = userProvider.currentUserMap;
        _userProfileImage = _currentUserInfo['profileImageLink']!;
        _username = _currentUserInfo['username']!;

        if (_username.length > 11) {
          _finalUsername = '${_username.substring(0, 11)}...';
        } else {
          _finalUsername = _username;
        }

        _mobileNo = _currentUserInfo['mobileNo']!;
      });
    });
  }

  Future<bool> _onBackPressed() async {
    return (await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Row(
                    children: [
                      Icon(Icons.exit_to_app),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Exit App',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                  content: Text(
                    'Do you really want to exit the app?',
                    style: TextStyle(color: Colors.black),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('No'),
                    ),
                    TextButton(
                      onPressed: () => SystemChannels.platform
                          .invokeMethod('SystemNavigator.pop'),
                      child: Text(
                        'Yes',
                        style: TextStyle(color: Colors.black),
                      ),
                    )
                  ],
                ))) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    if (_count == 0) _customInit(userProvider);
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          key: _scaffoldKey,
          drawer: Drawer(
            child: ListView(
              children: [
                DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.deepOrange,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: size.width * .08,
                          backgroundImage: _userProfileImage == ''
                              ? AssetImage('assets/profile_image_demo.png')
                              : NetworkImage(_userProfileImage)
                                  as ImageProvider,
                        ),
                        SizedBox(width: size.width * .04),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _finalUsername,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size.width * .06,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              _mobileNo,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: size.width * .04,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
                ProfileOption().showOption(context, 'Update account'),
                ProfileOption().showOption(context, 'Reset password'),
                ProfileOption().showOption(context, 'Logout'),
              ],
            ),
          ),
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.black,
              ),
              onPressed: () {
                if (_scaffoldKey.currentState!.isDrawerOpen) {
                  _scaffoldKey.currentState!.openEndDrawer();
                } else {
                  _scaffoldKey.currentState!.openDrawer();
                }
              },
            ),
            title:
                _currentIndex == 0 ? searchBar(context) : appBarTitle(context),
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          body: PageView(
            children: _tabs,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
                if (_currentIndex == 2) {
                  _appbarTitle = 'Conversation';
                } else if (_currentIndex == 1) {
                  _appbarTitle = 'Favourite';
                } else if (_currentIndex == 3) {
                  _appbarTitle = 'Account';
                } else {
                  _titleVisibility = true;
                }
              });
            },
            controller: _pageController,
          ),
          bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(
                canvasColor: Colors.white,
                primaryColor: Colors.deepOrange,
                textTheme: Theme.of(context)
                    .textTheme
                    .copyWith(caption: new TextStyle(color: Colors.grey))),
            child: new BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _currentIndex,
              items: [
                new BottomNavigationBarItem(
                    icon: new Icon(Icons.home), label: 'Home'),
                new BottomNavigationBarItem(
                    icon: new Icon(Icons.favorite_sharp), label: 'Favourite'),
                BottomNavigationBarItem(
                    icon: new Icon(FontAwesomeIcons.solidComment),
                    label: 'Chat'),
                BottomNavigationBarItem(
                    icon: new Icon(Icons.person), label: 'Account'),
              ],
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                  if (_currentIndex == 2) {
                    _appbarTitle = 'Conversation';
                  } else if (_currentIndex == 0) {
                    _titleVisibility = false;
                  } else if (_currentIndex == 1) {
                    _titleVisibility = true;

                    _appbarTitle = 'Favourite';
                  } else if (_currentIndex == 3) {
                    _titleVisibility = true;

                    _appbarTitle = 'Account';
                  }
                  _pageController.animateToPage(_currentIndex,
                      duration: Duration(milliseconds: 100),
                      curve: Curves.linear);
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget searchBar(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SearchPage()));
      },
      borderRadius: BorderRadius.circular(size.width * .2),
      child: Container(
        width: size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size.width * .2),
            border: Border.all(color: Colors.grey)),
        padding: EdgeInsets.fromLTRB(size.width * .03, size.width * .01,
            size.width * .03, size.width * .01),
        child: Row(
          children: [
            Icon(Icons.search, color: Colors.grey, size: size.width * .06),
            SizedBox(
              width: size.width * .04,
            ),
            Text(
              'Search',
              style: TextStyle(color: Colors.grey, fontSize: size.width * .04),
            )
          ],
        ),
      ),
    );
  }

  Widget appBarTitle(BuildContext context) {
    return Visibility(
      visible: _titleVisibility,
      child: Text('$_appbarTitle',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'MateSC',
          )),
    );
  }
}
