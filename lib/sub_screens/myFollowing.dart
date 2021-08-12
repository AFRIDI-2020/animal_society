import 'package:flutter/material.dart';
import 'package:pet_lover/custom_classes/DatabaseManager.dart';
import 'package:pet_lover/model/follower.dart';
import 'package:pet_lover/provider/userProvider.dart';
import 'package:pet_lover/sub_screens/other_user_profile.dart';
import 'package:provider/provider.dart';

class MyFollowing extends StatefulWidget {
  const MyFollowing({Key? key}) : super(key: key);

  @override
  _MyFollowingState createState() => _MyFollowingState();
}

class _MyFollowingState extends State<MyFollowing> {
  String mobileNo = '';

  int _count = 0;
  List<Follower>? _followingList;
  bool _loading = false;

  Future _customInit(UserProvider userProvider) async {
    setState(() {
      _count++;
    });
    mobileNo = await DatabaseManager().getCurrentMobileNo();
    await userProvider.getAllFollowingPeople(mobileNo).then((value) {
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
    );
  }

  Widget _bodyUI(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    if (_count == 0) _customInit(userProvider);
    return _loading
        ? Center(child: CircularProgressIndicator())
        : _followingList!.length == 0
            ? Padding(
                padding: EdgeInsets.all(size.width * .04),
                child: Text(
                  'You are follwoing nobody.',
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
