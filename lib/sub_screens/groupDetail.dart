import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pet_lover/demo_designs/group_animal_post.dart';
import 'package:pet_lover/demo_designs/group_menu_demo.dart';
import 'package:pet_lover/model/group_menu_item.dart';
import 'package:pet_lover/model/group_post.dart';
import 'package:pet_lover/model/member.dart';
import 'package:pet_lover/provider/groupProvider.dart';
import 'package:pet_lover/provider/userProvider.dart';
import 'package:pet_lover/sub_screens/AddPeopleInGroup.dart';
import 'package:pet_lover/sub_screens/allGroupMembers.dart';
import 'package:pet_lover/sub_screens/group_post_add.dart';
import 'package:provider/provider.dart';

class GroupDetail extends StatefulWidget {
  String groupId;
  GroupDetail({Key? key, required this.groupId}) : super(key: key);

  @override
  _GroupDetailState createState() => _GroupDetailState(groupId);
}

class _GroupDetailState extends State<GroupDetail> {
  String groupId;
  _GroupDetailState(this.groupId);

  Map<String, String> _groupInfo = {};
  Map<String, String> _currentUserInfo = {};
  int count = 0;
  String _groupName = '';
  String _groupImage = '';
  String _privacy = '';
  String _description = '';
  String _currentUserProfileImage = '';
  List<Member> _members = [];
  int _totalMembers = 0;
  bool? _isMember;

  List<GroupPost> _groupPostLists = [];
  ScrollController _scrollController = ScrollController();

  String? finalDate;
  Map<String, String> _currentUserInfoMap = {};

  Future _customInit(String groupId, GroupProvider groupProvider,
      UserProvider userProvider) async {
    _getGroupDetail(groupId, groupProvider);
    _isMemberOrNot(groupProvider, userProvider);
    _getCurrentUserDetail(userProvider);
    _getMembers(groupId, groupProvider, userProvider);
    setState(() {
      count++;
    });

    await userProvider.getCurrentUserInfo().then((value) {
      _currentUserInfoMap = userProvider.currentUserMap;
    });

    await groupProvider.getGroupPost(3, groupId).then((value) {
      setState(() {
        _groupPostLists = groupProvider.groupPostList;
      });
    });

    _scrollController.addListener(() {
      if (_scrollController.offset >=
          _scrollController.position.maxScrollExtent) {
        print('scrolling max and getting more animals');
        _getMoreAnimals(groupProvider);
        print('The animal list length = ${_groupPostLists.length}');
      }
    });
  }

  _getMoreAnimals(GroupProvider groupProvider) async {
    await groupProvider.getMorePost(3, groupId).then((value) {
      setState(() {
        _groupPostLists = groupProvider.groupPostList;
      });
    });
  }

  Future _onRefresh(
      UserProvider userProvider, GroupProvider groupProvider) async {
    await groupProvider.getGroupPost(3, groupId).then((value) {
      setState(() {
        //  _groupPostLists.clear();

        _groupPostLists = groupProvider.groupPostList;
      });
    });
  }

  _isMemberOrNot(GroupProvider groupProvider, UserProvider userProvider) async {
    String currentUserMobileNo = await userProvider.currentUserMobile;
    await groupProvider
        .isGroupMemberOrNot(groupId, currentUserMobileNo)
        .then((value) {
      setState(() {
        _isMember = groupProvider.isGroupMember;
      });
    });
  }

  _getMembers(String groupId, GroupProvider groupProvider,
      UserProvider userProvider) async {
    await groupProvider.getAllMembers(groupId).then((value) {
      setState(() {
        _members = groupProvider.members;
        _totalMembers = _members.length;
      });
    });
  }

  _getCurrentUserDetail(UserProvider userProvider) async {
    await userProvider.getCurrentUserInfo().then((value) {
      setState(() {
        _currentUserInfo = userProvider.currentUserMap;
        _currentUserProfileImage = _currentUserInfo['profileImageLink']!;
      });
    });
  }

  _getGroupDetail(String groupId, GroupProvider groupProvider) async {
    await groupProvider.getGroupInfo(groupId).then((value) {
      setState(() {
        _groupInfo = groupProvider.groupInfo;
        _groupName = _groupInfo['groupName']!;
        _groupImage = _groupInfo['groupImage']!;
        _privacy = _groupInfo['privacy']!;
        _description = _groupInfo['description']!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Group Details',
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
      resizeToAvoidBottomInset: false,
      body: _bodyUI(context),
    );
  }

  Widget _bodyUI(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final GroupProvider groupProvider = Provider.of<GroupProvider>(context);
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    if (count == 0) _customInit(groupId, groupProvider, userProvider);
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () => _onRefresh(userProvider, groupProvider),
        child: Container(
          width: size.width,
          height: size.height,
          child: ListView(
            controller: _scrollController,
            children: [
              Container(
                height: size.height * .35,
                color: Colors.grey.shade200,
                child: Stack(
                  children: [
                    Container(
                      width: size.width,
                      height: size.height * .35,
                      child: _groupImage == ''
                          ? Center(
                              child: Text(
                              _groupName,
                              style: TextStyle(fontSize: size.width * .05),
                            ))
                          : Image.network(
                              _groupImage,
                              fit: BoxFit.fill,
                            ),
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(
                      left: size.width * .04,
                      top: size.width * .02,
                      bottom: size.width * .02,
                      right: size.width * .02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _groupName,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: size.width * .06),
                      ),
                      PopupMenuButton<MenuItem>(
                          onSelected: (item) =>
                              onSelectedMenuItem(context, item),
                          itemBuilder: (context) => [
                                ...MenuItems.groupMenuItems
                                    .map(buildItem)
                                    .toList()
                              ])
                    ],
                  )),
              Padding(
                padding: EdgeInsets.only(
                    left: size.width * .04, right: size.width * .04),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.security, size: size.width * .042),
                    SizedBox(width: size.width * .01),
                    Text(
                      _privacy,
                      style: TextStyle(
                          color: Colors.black, fontSize: size.width * .04),
                    ),
                    SizedBox(width: size.width * .05),
                    Icon(Icons.group, size: size.width * .042),
                    SizedBox(width: size.width * .01),
                    Text(
                      _totalMembers.toString(),
                      style: TextStyle(
                          color: Colors.black, fontSize: size.width * .04),
                    ),
                    Text(
                      _totalMembers < 2 ? ' Member' : ' Members',
                      style: TextStyle(
                          color: Colors.black, fontSize: size.width * .04),
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.width * .035),
              Container(
                padding: EdgeInsets.only(
                  left: size.width * .04,
                  right: size.width * .04,
                ),
                width: size.width,
                child: Text(
                  _description,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: size.width * .04,
                  ),
                ),
              ),
              SizedBox(height: size.width * .03),
              _isMember == null
                  ? Container(
                      width: size.width,
                      child: Center(child: CircularProgressIndicator()))
                  : _isMember == true
                      ? forMemberOfGroup(context)
                      : Container(
                          width: size.width,
                          height: size.width * .1,
                          padding: EdgeInsets.only(
                              left: size.width * .04, right: size.width * .04),
                          child: ElevatedButton(
                              onPressed: () {},
                              child: Text(
                                'Join $_groupName',
                                style: TextStyle(
                                  fontSize: size.width * .04,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                        )
            ],
          ),
        ),
      ),
    );
  }

  Widget forMemberOfGroup(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(size.width * .04),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: _currentUserProfileImage == ''
                      ? AssetImage('assets/profile_image_demo.png')
                      : NetworkImage(_currentUserProfileImage) as ImageProvider,
                  radius: size.width * .05,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GroupPostAdd(groupId: groupId)),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: size.width * .04),
                    child: Container(
                      width: size.width * .73,
                      padding: EdgeInsets.fromLTRB(size.width * .03,
                          size.width * .02, size.width * .03, size.width * .02),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(size.width * .04),
                        border: Border.all(color: Colors.black),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Write something...',
                          style: TextStyle(
                            fontSize: size.width * .035,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Divider(
              thickness: size.width * .002,
              color: Colors.grey,
              height: size.width * .01),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                GroupPostAdd(groupId: groupId)),
                      );
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.camera_alt,
                        ),
                        SizedBox(
                          width: size.width * .02,
                        ),
                        Text(
                          'Photo',
                          style: TextStyle(
                              fontSize: size.width * .04, color: Colors.black),
                        ),
                      ],
                    )),
                Container(
                  height: size.width * .06,
                  child: VerticalDivider(
                    thickness: size.width * .002,
                    color: Colors.black,
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                GroupPostAdd(groupId: groupId)),
                      );
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.video_camera_back_outlined,
                        ),
                        SizedBox(
                          width: size.width * .02,
                        ),
                        Text(
                          'Video',
                          style: TextStyle(
                              fontSize: size.width * .04, color: Colors.black),
                        ),
                      ],
                    ))
              ],
            ),
          ),
          Divider(
              thickness: size.width * .002,
              color: Colors.grey,
              height: size.width * .01),
          ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: _groupPostLists.length,
            itemBuilder: (context, index) {
              DateTime miliDate = new DateTime.fromMillisecondsSinceEpoch(
                  int.parse(_groupPostLists[index].date!));
              var format = new DateFormat("yMMMd").add_jm();
              finalDate = format.format(miliDate);

              return GroupAnimalPost(
                profileImageLink: _groupPostLists[index].userProfileImage!,
                username: _groupPostLists[index].username!,
                mobile: _groupPostLists[index].mobile!,
                date: finalDate!,
                numberOfLoveReacts: _groupPostLists[index].totalFollowings!,
                numberOfComments: _groupPostLists[index].totalComments!,
                numberOfShares: _groupPostLists[index].totalShares!,
                petId: _groupPostLists[index].id!,
                petName: _groupPostLists[index].petName!,
                petColor: _groupPostLists[index].color!,
                petGenus: _groupPostLists[index].genus!,
                petGender: _groupPostLists[index].gender!,
                petAge: _groupPostLists[index].age!,
                petImage: _groupPostLists[index].photo!,
                petVideo: _groupPostLists[index].video!,
                currentUserImage: _currentUserInfoMap['profileImageLink']!,
                status: _groupPostLists[index].status!,
                groupId: _groupPostLists[index].groupId!,
              );
            },
          ),
        ],
      ),
    );
  }

  PopupMenuItem<MenuItem> buildItem(MenuItem item) => PopupMenuItem<MenuItem>(
      value: item,
      child: Row(
        children: [
          Icon(item.iconData),
          SizedBox(
            width: 10,
          ),
          Text(item.text)
        ],
      ));

  onSelectedMenuItem(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.itemAddPeople:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddPeopleInGroup(groupId: groupId)));
        break;
      case MenuItems.allMembers:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AllGroupMembers(groupId: groupId)));
        break;
    }
  }
}
