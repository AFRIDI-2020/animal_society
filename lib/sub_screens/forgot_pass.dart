import 'package:flutter/material.dart';
import 'package:pet_lover/sub_screens/confirm_pass.dart';

class Forgot_pass extends StatefulWidget {
  const Forgot_pass({Key? key}) : super(key: key);

  @override
  _Forgot_passState createState() => _Forgot_passState();
}

class _Forgot_passState extends State<Forgot_pass> {
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
                height: size.width * .45,
                color: Colors.white,
                child: Icon(
                  Icons.phonelink_lock,
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
                      'FORGET',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'PASSWORD',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.all(size.width * .02),
                      child: Text(
                        'Provide your accounts phone number for which you want to reset your password!',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                width: size.width,
                height: size.width * .17,
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
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(
                            size.width * .05,
                            size.width * .04,
                            size.width * .05,
                            0.0,
                          ),
                          prefixIcon: Icon(
                            Icons.phone_android_outlined,
                          ),
                          labelText: 'Phone Number',
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Confirm_pass()));
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
