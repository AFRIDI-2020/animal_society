import 'package:flutter/material.dart';

class ChatNav extends StatefulWidget {
  @override
  _ChatNavState createState() => _ChatNavState();
}

class _ChatNavState extends State<ChatNav> {
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyUI(context),
    );
  }

  Widget _bodyUI(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(size.width * .04, size.width * .03,
                size.width * .04, size.width * .03),
            child: Container(
              width: size.width,
              child: Padding(
                padding: EdgeInsets.fromLTRB(size.width * .025,
                    size.width * .025, size.width * .02, size.width * .025),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: size.width * .02,
                    ),
                    Container(
                      width: size.width * .7,
                      child: TextFormField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search',
                          hintStyle: TextStyle(fontSize: size.width * .038),
                          isDense: true,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        cursorColor: Colors.black,
                      ),
                    )
                  ],
                ),
              ),
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.all(Radius.circular(size.width * .04)),
                color: Colors.grey[300],
              ),
            ),
          ),
          Container(
              width: size.width,
              child: Column(
                children: [
                  _messageUI(context),
                  _messageUI(context),
                  _messageUI(context),
                ],
              ))
        ],
      ),
    );
  }

  Widget _messageUI(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      child: Padding(
        padding: EdgeInsets.fromLTRB(size.width * .03, size.width * .02,
            size.width * .02, size.width * .02),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/profile_image.jpg'),
              radius: size.width * .06,
            ),
            Container(
              width: size.width * .8,
              child: Padding(
                padding: EdgeInsets.fromLTRB(size.width * .03, size.width * .02,
                    size.width * .02, size.width * .02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: size.width * .7,
                      child: Text(
                        'Gal Gadot',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                        width: size.width * .7,
                        child: Text(
                          'What\'s up? How are you?',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
