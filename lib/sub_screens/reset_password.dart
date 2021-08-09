import 'package:flutter/material.dart';
import 'package:pet_lover/provider/userProvider.dart';
import 'package:pet_lover/sub_screens/pass_update.dart';
import 'package:provider/provider.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  Map<String, String> _currentUserInfoMap = {};
  int _count = 0;
  String _password = '';
  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPassswordController = TextEditingController();
  String? _oldPasswordError;
  String? _newPasswordError;
  String? _confirmPasswordError;
  bool _loading = false;

  _customInit(UserProvider userProvider) async {
    setState(() {
      _count++;
    });

    await userProvider.getCurrentUserInfo().then((value) {
      setState(() {
        _currentUserInfoMap = userProvider.currentUserMap;
        _password = _currentUserInfoMap['passowrd']!;
        print('previous password = $_password');
      });
    });
  }

  _resetPassword(UserProvider userProvider, String newPassword) async {
    print('reseting password');
    if (_password == _oldPasswordController.text) {
      await userProvider.resetPassword(newPassword).then((value) {
        // setState(() {
        //   _loading = false;
        // });
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Pass_update()),
            (route) => false);
      });
    } else {
      _showToast(context, 'Wrong old password!');
    }
  }

  _showToast(BuildContext context, String text) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    if (_count == 0) _customInit(userProvider);
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
                      'RESET',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'PASSWORD',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(size.width * .02,
                          size.width * .02, size.width * .02, 0.0),
                      child: Text(
                        'Set a strong password & protect your account',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          size.width * .02, 0.0, size.width * .02, 0.0),
                      child: Text(
                        'Password must be of more than 6 digits',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                width: size.width,
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
                        controller: _oldPasswordController,
                        cursorColor: Colors.black,
                        obscureText: true,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(
                            size.width * .05,
                            size.width * .04,
                            size.width * .05,
                            0.0,
                          ),
                          errorText: _oldPasswordError,
                          prefixIcon: Icon(
                            Icons.vpn_key,
                          ),
                          labelText: 'Old Password',
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
                        controller: _newPasswordController,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(
                            size.width * .05,
                            size.width * .04,
                            size.width * .05,
                            0.0,
                          ),
                          errorText: _newPasswordError,
                          prefixIcon: Icon(
                            Icons.vpn_key,
                          ),
                          suffix: Icon(
                            Icons.visibility,
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
                        controller: _confirmPassswordController,
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
                          errorText: _confirmPasswordError,
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
              SizedBox(
                height: size.width * .03,
                width: size.width,
              ),
              Container(
                width: size.width,
                height: size.width * .14,
                padding: EdgeInsets.fromLTRB(
                    size.width * .06, 0.0, size.width * .06, 0.0),
                child: _loading == true
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                        ],
                      )
                    : ElevatedButton(
                        child: Text(
                          'Reset',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _loading = true;
                            print('loading = $_loading');
                            if (_oldPasswordController.text.isEmpty) {
                              _oldPasswordError = 'Old password required!';
                              _loading = false;
                              return;
                            } else {
                              _oldPasswordError = null;
                            }
                            if (_newPasswordController.text.length < 6 ||
                                _newPasswordController.text.isEmpty) {
                              _newPasswordError = 'At least 6 digits required!';
                              _loading = false;

                              return;
                            } else {
                              _newPasswordError = null;
                            }

                            if (_confirmPassswordController.text !=
                                _newPasswordController.text) {
                              _confirmPasswordError =
                                  'New passwords does not match!';
                              _loading = false;
                              return;
                            } else {
                              _confirmPasswordError = null;
                            }

                            _oldPasswordError = null;
                            _newPasswordError = null;
                            _confirmPasswordError = null;
                            _resetPassword(
                                userProvider, _newPasswordController.text);
                          });
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.deepOrange),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(size.width * .04),
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
