import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_lover/model/Comment.dart';

class CommentsDemo extends StatefulWidget {
  Comment? comment;
  CommentsDemo({this.comment});

  @override
  _CommentsDemoState createState() => _CommentsDemoState();
}

class _CommentsDemoState extends State<CommentsDemo> {
  String? date;

  String? _commenterImage;
  String? _commenterName;

  Future _getCommenter(String commenter) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(commenter)
        .get()
        .then((snapshot) {
      setState(() {
        _commenterImage = snapshot['profileImageLink'];
        _commenterName = snapshot['username'];
      });
    });
  }

  _getCommentsTime() {
    DateTime now = DateTime.now();
    int commentDurationInSec = now
        .difference(DateTime.fromMillisecondsSinceEpoch(
            int.parse(widget.comment!.date!)))
        .inSeconds;
    int day = commentDurationInSec ~/ (24 * 3600);
    commentDurationInSec = commentDurationInSec % (24 * 3600);
    int hour = commentDurationInSec ~/ 3600;
    commentDurationInSec %= 3600;
    int min = commentDurationInSec ~/ 60;
    commentDurationInSec %= 60;
    int sec = commentDurationInSec;

    if (day == 0 && hour == 0 && min == 0 && sec < 60) {
      date = 'just now';
    } else if (day == 0 && hour == 0 && min != 0 && sec < 60) {
      date = min.toString() + ' min';
    } else if (day == 0 && hour != 0 && min != 0 && sec != 0) {
      date = hour.toString() + ' hour' + ' ' + min.toString() + ' min';
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    _getCommenter(widget.comment!.currentUserMobileNo!);
    _getCommentsTime();

    return Container(
      width: size.width,
      padding: EdgeInsets.all(size.width * .03),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: _commenterImage == null || _commenterImage == ''
                ? AssetImage('assets/profile_image_demo.png')
                : NetworkImage(_commenterImage!) as ImageProvider,
            radius: size.width * .04,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: size.width * .03),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        left: size.width * .04,
                        right: size.width * .04,
                        top: size.width * .03,
                        bottom: size.width * .03),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(size.width * .02)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _commenterName == null ? '' : _commenterName!,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: size.width * .04),
                        ),
                        Text(
                          widget.comment!.comment!,
                          style: TextStyle(
                              color: Colors.black, fontSize: size.width * .04),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.width * .02,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: size.width * .04),
                    child: Text(
                      date!,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
