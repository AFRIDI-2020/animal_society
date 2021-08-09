import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_lover/login.dart';

class Pass_update extends StatefulWidget {
  const Pass_update({Key? key}) : super(key: key);

  @override
  _Pass_updateState createState() => _Pass_updateState();
}

class _Pass_updateState extends State<Pass_update> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: size.width,
                height: size.width * .65,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'PASSWORD',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'UPDATED',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 35,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.check_circle,
                size: size.height * .2,
                color: Colors.deepOrange,
              ),
              SizedBox(
                height: size.width * .03,
              ),
              Text('Your Password has been updated'),
              SizedBox(
                height: size.width * .03,
              ),
              Container(
                width: size.width,
                height: size.width * .14,
                padding: EdgeInsets.fromLTRB(
                    size.width * .22, 0.0, size.width * .22, 0.0),
                child: ElevatedButton(
                  child: Text(
                    'LOGIN',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => Login()),
                        (route) => false);
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