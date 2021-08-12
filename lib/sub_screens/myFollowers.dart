import 'package:flutter/material.dart';
import 'package:pet_lover/custom_classes/DatabaseManager.dart';
import 'package:pet_lover/model/follower.dart';
import 'package:pet_lover/provider/userProvider.dart';
import 'package:pet_lover/sub_screens/other_user_profile.dart';
import 'package:provider/provider.dart';

class MyFollowers extends StatefulWidget {
  const MyFollowers({Key? key}) : super(key: key);

  @override
  _MyFollowersState createState() => _MyFollowersState();
}

class _MyFollowersState extends State<MyFollowers> {
  int _count = 0;
  List<Follower> _followerList = [];
  bool _loading = false;

  Future _customInit(UserProvider userProvider) async {
    setState(() {
      _count++;
      _loading = true;
    });

    String mobileNo = userProvider.currentUserMobile;

    await userProvider.getAllFollowers(mobileNo).then((value) {
      if (value) {
        setState(() {
          _followerList = userProvider.followerList;
          _loading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'You\'re following',
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
    if (_count == 0) _customInit(userProvider);
    return _loading
        ? Center(child: CircularProgressIndicator())
        : userProvider.followerList.isNotEmpty
            ? ListView.builder(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: _followerList.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.only(
                      left: size.width * .02,
                      right: size.width * .02,
                    ),
                    child: Card(
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OtherUserProfile(
                                      userMobileNo:
                                          _followerList[index].mobileNo,
                                      username: _followerList[index].name)));
                        },
                        leading: CircleAvatar(
                          backgroundImage: _followerList[index].photo == ''
                              ? AssetImage('assets/profile_image_demo.png')
                              : NetworkImage(_followerList[index].photo)
                                  as ImageProvider,
                        ),
                        title: Text(
                          _followerList[index].name,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  );
                })
            : Center(
                child: Text(
                  'You have no followers',
                  style: TextStyle(fontSize: size.width * .04),
                ),
              );
  }
}
