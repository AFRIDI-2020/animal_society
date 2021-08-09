import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_lover/sub_screens/pass_update.dart';

class Confirm_pass extends StatefulWidget {
  const Confirm_pass({Key? key}) : super(key: key);

  @override
  _Confirm_passState createState() => _Confirm_passState();
}

class _Confirm_passState extends State<Confirm_pass> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: size.width,
                height: AppBar().preferredSize.height,
                color: Colors.white,
                child: Row(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.fromLTRB(size.width * .04, 0.0, 0.0, 0.0),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.deepOrange,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: size.width,
                height: size.width * .40,
                color: Colors.white,
                child: Icon(
                  Icons.vpn_key,
                  size: size.width * .30,
                ),
              ),
              Container(
                width: size.width,
                height: size.width * .35,
                color: Colors.white,
                child: Column(
                  children: [
                    Text(
                      'NEW',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'CREDENTIALS',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(size.width * .02,
                          size.width * .02, size.width * .02, 0.0),
                      child: Text(
                        'Your identity has been verified.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          size.width * .02, 0.0, size.width * .02, 0.0),
                      child: Text(
                        'Set your new password',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                width: size.width,
                height: size.width * .33,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        size.width * .06,
                        0.0,
                        size.width * .06,
                        0.0,
                      ),
                      child: TextField(
                        cursorColor: Colors.black,
                        obscureText: true,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(
                            size.width * .05,
                            size.width * .04,
                            size.width * .05,
                            0.0,
                          ),
                          prefixIcon: Icon(
                            Icons.vpn_key,
                          ),
                          labelText: 'New Password',
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(size.width * .04),
                            borderSide: BorderSide(
                              color: Colors.deepOrange,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(size.width * .04),
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(size.width * .04),
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(size.width * .04),
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.width * .03,
                      width: size.width,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        size.width * .06,
                        0.0,
                        size.width * .06,
                        0.0,
                      ),
                      child: TextField(
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(
                            size.width * .05,
                            size.width * .04,
                            size.width * .05,
                            0.0,
                          ),
                          prefixIcon: Icon(
                            Icons.vpn_key,
                          ),
                          suffix: Icon(
                            Icons.visibility,
                          ),
                          labelText: 'Confirm Password',
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(size.width * .04),
                            borderSide: BorderSide(
                              color: Colors.deepOrange,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(size.width * .04),
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(size.width * .04),
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(size.width * .04),
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: size.width,
                height: size.width * .14,
                padding: EdgeInsets.fromLTRB(
                    size.width * .06, 0.0, size.width * .06, 0.0),
                child: ElevatedButton(
                  child: Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Pass_update()));
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.deepOrange),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(size.width * .04),
                      ))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
