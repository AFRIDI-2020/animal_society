import 'package:flutter/material.dart';
import 'package:pet_lover/model/group_menu_item.dart';

class MenuItems {
  static const List<MenuItem> groupMenuItems = [
    itemAddPeople,
    allMembers,
    itemLeaveGroup,
  ];
  static const itemAddPeople =
      MenuItem(text: 'Add people', iconData: Icons.person_add);
  static const allMembers =
      MenuItem(text: 'All members', iconData: Icons.group);
  static const itemLeaveGroup =
      MenuItem(text: 'Leave group', iconData: Icons.time_to_leave_outlined);
}
