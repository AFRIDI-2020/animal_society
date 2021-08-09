import 'package:flutter/material.dart';
import 'package:pet_lover/model/follower.dart';
import 'package:pet_lover/provider/userProvider.dart';
import 'package:pet_lover/sub_screens/other_user_profile.dart';
import 'package:provider/provider.dart';

class UserFollowers extends StatefulWidget {
  String userMobileNo;
  String username;
  UserFollowers({Key? key, required this.userMobileNo, required this.username})
      : super(key: key);

  @override
  _UserFollowersState createState() =>
      _UserFollowersState(userMobileNo, username);
}

class _UserFollowersState extends State<UserFollowers> {
  String userMobileNo;
  String username;
  _UserFollowersState(this.userMobileNo, this.username);
  int _count = 0;
  List<Follower> _followerList = [];

  Future _customInit(UserProvider userProvider) async {
    setState(() {
      _count++;
    });

    await userProvider.getAllFollowers(userMobileNo).then((value) {
      setState(() {
        _followerList = userProvider.followerList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Followers of $username',
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
    return _followerList.length == 0
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
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
                                  userMobileNo: _followerList[index].mobileNo,
                                  username: _followerList[index].name)));
                    },
                    leading: CircleAvatar(
                      backgroundImage: _followerList[index].photo == ''
                          ? AssetImage('assets/profile_image_demo.jpg')
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
            });
  }
}
