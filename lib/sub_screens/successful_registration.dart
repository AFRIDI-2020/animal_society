import 'package:flutter/material.dart';
import 'package:pet_lover/login.dart';

class RegistrationSuccessful extends StatefulWidget {
  const RegistrationSuccessful({Key? key}) : super(key: key);

  @override
  _RegistrationSuccessfulState createState() => _RegistrationSuccessfulState();
}

class _RegistrationSuccessfulState extends State<RegistrationSuccessful> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: _bodyUI(context),
    );
  }

  Widget _bodyUI(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'REGISTRATION',
            style: TextStyle(
                color: Colors.black,
                fontSize: size.width * .08,
                fontWeight: FontWeight.bold),
          ),
          Text(
            'SUCCESSFUL',
            style: TextStyle(
                color: Colors.black,
                fontSize: size.width * .08,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: size.width * .05,
          ),
          Icon(
            Icons.check_circle_sharp,
            color: Colors.deepOrange,
            size: size.width * .3,
          ),
          SizedBox(
            height: size.width * .05,
          ),
          Text(
            'Welcome to Animal Society',
            style: TextStyle(
                color: Colors.black,
                fontSize: size.width * .05,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: size.width * .02,
          ),
          Container(
              width: size.width,
              height: size.width * .13,
              padding: EdgeInsets.only(
                  left: size.width * .06,
                  right: size.width * .06,
                  top: size.width * .02),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      (MaterialPageRoute(builder: (context) => Login())));
                },
                child: Text(
                  'GET STARTED',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size.width * .04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ))),
              ))
        ],
      ),
    );
  }
}
