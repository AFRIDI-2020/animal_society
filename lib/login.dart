import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pet_lover/custom_classes/DatabaseManager.dart';
import 'package:pet_lover/custom_classes/TextFieldValidation.dart';
import 'package:pet_lover/custom_classes/progress_dialog.dart';
import 'package:pet_lover/demo_designs/text_field_demo.dart';
import 'package:pet_lover/home.dart';
import 'package:pet_lover/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _mobileNoController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String? _mobileNoErrorText;
  String? _passwordErrorText;
  bool obscureText = true;

  Future<bool> _onBackPressed() async {
    return (await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Row(
                    children: [
                      Icon(Icons.exit_to_app),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Exit App',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                  content: Text(
                    'Do you really want to exit the app?',
                    style: TextStyle(color: Colors.black),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('No'),
                    ),
                    TextButton(
                      onPressed: () => SystemChannels.platform
                          .invokeMethod('SystemNavigator.pop'),
                      child: Text(
                        'Yes',
                        style: TextStyle(color: Colors.green),
                      ),
                    )
                  ],
                ))) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.deepOrange,
        appBar: AppBar(
          elevation: 0.0,
          title: Text(
            'Login',
          ),
        ),
        body: _bodyUI(context),
      ),
    );
  }

  Widget _bodyUI(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 30.0,
            child: Column(
              children: [
                Container(
                  width: size.width,
                  height: size.height * .15,
                  padding: EdgeInsets.only(bottom: size.width * .06),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Animal Society',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: size.width * .1,
                            fontFamily: 'MateSC',
                            fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(FontAwesomeIcons.paw,
                              size: size.width * .04, color: Colors.white),
                          SizedBox(width: size.width * .03),
                          Text(
                            'A community for pet lovers',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: size.width * .045,
                            ),
                          ),
                          SizedBox(width: size.width * .03),
                          Icon(FontAwesomeIcons.paw,
                              size: size.width * .04, color: Colors.white),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Positioned(
            bottom: 0.0,
            child: Container(
              height: size.height * .70,
              width: size.width,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(size.width * .15),
                    topLeft: Radius.circular(size.width * .15),
                  ),
                ),
                margin: EdgeInsets.all(0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          size.width * .05, size.width * .15, 0.0, 0.0),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.deepOrange,
                          fontSize: size.width * .06,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          size.width * .05, size.width * .02, 0.0, 0.0),
                      child: Text(
                        'Get logged in for better experience',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: size.width * .032,
                        ),
                      ),
                    ),
                    Container(
                      width: size.width,
                      padding: EdgeInsets.fromLTRB(
                          size.width * .05, 20.0, size.width * .05, 0.0),
                      child: TextFieldBuilder().showtextFormBuilder(
                          context,
                          'Mobile number',
                          Icons.phone_android_outlined,
                          _mobileNoController,
                          _mobileNoErrorText,
                          false,
                          null),
                    ),
                    Container(
                      width: size.width,
                      padding: EdgeInsets.fromLTRB(
                          size.width * .05, 20.0, size.width * .05, 0.0),
                      child: TextFieldBuilder().showtextFormBuilder(
                          context,
                          'Password',
                          Icons.vpn_key,
                          _passwordController,
                          _passwordErrorText,
                          obscureText,
                          InkWell(
                              onTap: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              },
                              child: Icon(
                                obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.deepOrange,
                              ))),
                    ),
                    Container(
                      width: size.width,
                      height: size.width * .18,
                      padding: EdgeInsets.fromLTRB(
                          size.width * .05, 20.0, size.width * .05, 0.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (!TextFieldValidation()
                                .mobileNoValidate(_mobileNoController.text)) {
                              _mobileNoErrorText = 'Invalid mobile number!';
                              return;
                            } else {
                              _mobileNoErrorText = null;
                            }
                            if (!TextFieldValidation()
                                .passwordValidation(_passwordController.text)) {
                              _passwordErrorText =
                                  'Password must be of at least 6 digits!';
                              return;
                            } else {
                              _passwordErrorText = null;
                            }

                            login(context);
                          });
                        },
                        child: Text(
                          'LOG IN',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: size.width * .04,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ))),
                      ),
                    ),
                    Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: size.width * .04),
                        width: size.width,
                        child: TextButton(
                          child: Text(
                            'Forget password?',
                            style: TextStyle(
                              color: Colors.deepOrange,
                              fontSize: size.width * .038,
                            ),
                          ),
                          onPressed: () {},
                        )),
                    Expanded(
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        padding: EdgeInsets.only(
                          bottom: size.width * .1,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Do not have account?',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: size.width * .038,
                              ),
                            ),
                            SizedBox(
                              width: size.width * .02,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Register()));
                              },
                              child: Text(
                                'Register here',
                                style: TextStyle(
                                  color: Colors.deepOrange,
                                  fontSize: size.width * .038,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> login(BuildContext context) async {
    try {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return ProgressDialog(
                message: 'Please wait... while we let you logged in.');
          });
      if (await DatabaseManager().checkMobileNoPassword(
              _mobileNoController.text, _passwordController.text) ==
          true) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('mobileNo', _mobileNoController.text);
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Home()));
        // Navigator.pushAndRemoveUntil(context,
        //     MaterialPageRoute(builder: (context) => Home()), (route) => false);
      } else {
        print('Not registered yet!');
        Navigator.pop(context);
      }
    } catch (error) {
      Navigator.pop(context);
      print('Login failed - $error');
    }
  }
}
