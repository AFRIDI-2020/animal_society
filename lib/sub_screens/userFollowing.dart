import 'package:flutter/material.dart';
import 'package:pet_lover/model/follower.dart';
import 'package:pet_lover/provider/userProvider.dart';
import 'package:pet_lover/sub_screens/other_user_profile.dart';
import 'package:provider/provider.dart';

class UserFollowing extends StatefulWidget {
  String userMobileNo;
  String username;
  UserFollowing({Key? key, required this.userMobileNo, required this.username})
      : super(key: key);

  @override
  _UserFollowingState createState() =>
      _UserFollowingState(userMobileNo, username);
}

class _UserFollowingState extends State<UserFollowing> {
  String userMobileNo;
  String username;
  _UserFollowingState(this.userMobileNo, this.username);

  int _count = 0;
  List<Follower>? _followingList;

  Future _customInit(UserProvider userProvider) async {
    setState(() {
      _count++;
    });

    await userProvider.getAllFollowingPeople(userMobileNo).then((value) {
      setState(() {
        _followingList = userProvider.followingList;
        print('length = ${_followingList!.length}');
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
    return _followingList == null
        ? Center(child: CircularProgressIndicator())
        : _followingList!.length == 0
            ? Padding(
                padding: EdgeInsets.all(size.width * .04),
                child: Text(
                  'This person is follwoing nobody.',
                  style: TextStyle(fontSize: size.width * .04),
                ),
              )
            : ListView.builder(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: _followingList!.length,
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
                                          _followingList![index].mobileNo,
                                      username: _followingList![index].name)));
                        },
                        leading: CircleAvatar(
                          backgroundImage: _followingList![index].photo == ''
                              ? AssetImage('assets/profile_image_demo.jpg')
                              : NetworkImage(_followingList![index].photo)
                                  as ImageProvider,
                        ),
                        title: Text(
                          _followingList![index].name,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  );
                });
  }
}
