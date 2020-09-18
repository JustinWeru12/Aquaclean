import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:aquaclean/services/auth.dart';
import 'package:aquaclean/services/crud.dart';
import 'package:aquaclean/services/user.dart';
import 'package:flutter/material.dart';
import 'package:aquaclean/style/theme.dart';

class LoginSignUpPage extends StatefulWidget {
  LoginSignUpPage({Key key, this.auth, this.loginCallback, this.title})
      : super(key: key);

  final String title;
  final BaseAuth auth;
  final VoidCallback loginCallback;
  @override
  _LoginSignUpPageState createState() => _LoginSignUpPageState();
}

enum FormType { login, register, reset }

class _LoginSignUpPageState extends State<LoginSignUpPage>
    with TickerProviderStateMixin {
  var mainColor = Color(0xFF0088FF);
  FormType _formType = FormType.login;
  static final _formKey = new GlobalKey<FormState>();
  final TextEditingController _passwordTextController = TextEditingController();
  CrudMethods crudObj = new CrudMethods();
  String _email;
  String _fullNames;
  File picture;
  bool admin = false;
  double offset = 0;
  String _authHint = '';
  String _password;
  // String _errorMessage;

  // bool _isLoginForm;
  // ignore: unused_field
  bool _isLoading = false;
  Color dobColor = Colors.yellowAccent;

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Perform login or signup
  void validateAndSubmit() async {
    if (validateAndSave()) {
      setState(() {
        _isLoading = true;
      });
      try {
        String userId = _formType == FormType.login
            ? await widget.auth.signIn(_email, _password)
            : await widget.auth.signUp(_email, _password);
        setState(() {
          _isLoading = false;
        });
        if (_formType == FormType.register) {
          UserData userData = new UserData(
            fullNames: _fullNames,
            email: _email,
            phone: "",
            favorites: [],
            picture:
                "https://firebasestorage.googleapis.com/v0/b/covid19-ke-80e90.appspot.com/o/IMG_-oxvq7.jpg?alt=media&token=b8d2972a-e54c-49ff-8c4c-c869bd9d9592",
            admin: admin,
          );
          crudObj.createOrUpdateUserData(userData.getDataMap());
        }

        if (userId == null) {
          print("EMAIL NOT VERIFIED");
          setState(() {
            _authHint = 'Check your email for a verify link';
            _isLoading = false;
            _formType = FormType.login;
          });
        } else {
          _isLoading = false;
          _authHint = '';
          widget.loginCallback();
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
          switch (e.code) {
            case "ERROR_INVALID_EMAIL":
              _authHint = "Your email address appears to be malformed.";
              break;
            case "ERROR_EMAIL_ALREADY_IN_USE":
              _authHint = "Email address already used in a different account.";
              break;
            case "ERROR_WRONG_PASSWORD":
              _authHint = "Your password is wrong.";
              break;
            case "ERROR_USER_NOT_FOUND":
              _authHint = "User with this email doesn't exist.";
              break;
             case "EMAIL NOT VERIFIED":
              _authHint = "Email not verified: Please go to yor email and verify";
              break;
            case "ERROR_USER_DISABLED":
              _authHint = "User with this email has been disabled.";
              break;
            case "ERROR_TOO_MANY_REQUESTS":
              _authHint =
                  "Too many Attemps. Account has temporarily disabled.\n Try again later.";
              break;
            case "ERROR_OPERATION_NOT_ALLOWED":
              _authHint = "Signing in with Email and Password is not enabled.";
              break;
            case "ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL":
              _authHint = "The email is in use by another account";
              break;
            default:
              _authHint = "An undefined Error happened.";
          }
        });
        print(e);
        errorDialog(context, _authHint);
      }
    } else {
      setState(() {
        _authHint = '';
      });
    }
  }

  void moveToRegister() {
    _formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToReset() {
    _formKey.currentState.reset();
    setState(() {
      _formType = FormType.reset;
    });
  }

  void moveToLogin() {
    _formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var halfSide = MediaQuery.of(context).size.width / 2;
    var side = halfSide * sqrt(2);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kBackgroundColor,
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Container(
              color: kBackgroundColor,
            ),
          ),
          Image.asset(
            'assets/bg.webp',
            height: MediaQuery.of(context).size.height * 0.55,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Align(
            alignment: Alignment(0, 0.20),
            child: Transform.rotate(
              angle: pi / 4,
              child: Material(
                elevation: 5,
                shadowColor: Colors.black,
                color: mainColor,
                borderRadius: BorderRadius.circular(32),
                child: Container(
                  height: side * 1.05,
                  width: side * 1.05,
                  child: Transform.rotate(
                    angle: -pi / 4,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: _buildForm(),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 22),
              child: InkWell(
                onTap: () {
                  setState(() {
                    if (_formType == FormType.login) {
                      _formType = FormType.register;
                    } else {
                      _formType = FormType.login;
                    }
                  });
                },
                child: Text(
                  _formType == FormType.login
                      ? 'Create a New Account'
                      : 'Go To Sign In',
                  style: TextStyle(
                    color: mainColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _formType == FormType.login
                ? Padding(
                    padding: EdgeInsets.only(bottom: 62),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if (_formType == FormType.login) {
                            _formType = FormType.reset;
                          } else {
                            _formType = FormType.login;
                          }
                        });
                      },
                      child: Text(
                        'Reset Password',
                        style: TextStyle(
                          color: mainColor,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  )
                : Container(),
          ),
          Align(
            alignment: Alignment(0, -0.7),
            child: Icon(
              Icons.camera,
              color: Colors.white,
              size: 90,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildEmailField(_borders) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        validator: (String value) {
          if (value.isEmpty ||
              !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                  .hasMatch(value)) {
            return 'Enter a valid email';
          }
          return null;
        },
        onSaved: (value) => _email = value,
        style: TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
          filled: false,
          contentPadding: EdgeInsets.all(10),
          enabledBorder: _borders,
          focusedBorder: _borders,
          hintText: 'Your Email',
          hintStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildNameField(_borders) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.55,
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(
          color: Colors.white,
        ),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Enter your Name';
          }
          return null;
        },
        onSaved: (value) => _fullNames = value,
        decoration: InputDecoration(
          filled: false,
          contentPadding: EdgeInsets.all(10),
          enabledBorder: _borders,
          focusedBorder: _borders,
          hintText: 'Your Name',
          hintStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(_borders) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      child: TextFormField(
        keyboardType: TextInputType.visiblePassword,
        controller: _passwordTextController,
        obscureText: true,
        validator: (String value) {
          if (value.isEmpty || value.length < 6) {
            return 'Enter a minimum of 6 characters';
          }
          return null;
        },
        onSaved: (value) => _password = value,
        style: TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
          filled: false,
          contentPadding: EdgeInsets.all(10),
          enabledBorder: _borders,
          focusedBorder: _borders,
          hintText: 'Your Password',
          hintStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmPasswordField(_borders) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.55,
      child: TextFormField(
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
        validator: (String value) {
          if (_passwordTextController.text != value) {
            return 'Passwords don\'t correspond';
          }
          return null;
        },
        style: TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
          filled: false,
          contentPadding: EdgeInsets.all(10),
          enabledBorder: _borders,
          focusedBorder: _borders,
          hintText: 'Confirm Password',
          hintStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    var _borders = OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(32));
    var halfSide = MediaQuery.of(context).size.width / 2;
    var side = halfSide * sqrt(2);
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints:
            BoxConstraints(minWidth: side * 1.05, minHeight: side * 1.05),
        child: IntrinsicHeight(
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 5),
                  Text(
                    _formType == FormType.login
                        ? 'Login'
                        : _formType == FormType.register ? 'Register' : 'Reset',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 10),
                  _formType == FormType.register
                      ? _buildNameField(_borders)
                      : Container(),
                  _buildEmailField(_borders),
                  // SizedBox(height: 16),
                  _formType != FormType.reset
                      ? _buildPasswordField(_borders)
                      : Container(),
                  _formType == FormType.register
                      ? _buildConfirmPasswordField(_borders)
                      : Container(),
                  SizedBox(height: 10),
                  RaisedButton(
                    onPressed: () {
                      if (_formType != FormType.reset) {
                        validateAndSubmit();
                      } else {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          widget.auth.resetPassword(_email);
                          setState(() {
                            _authHint = 'Check your email';
                            _formType = FormType.login;
                          });
                        }
                      }
                    },
                    color: Colors.white,
                    splashColor: Colors.blue,
                    child: Text(
                      _formType == FormType.login
                          ? 'Login'
                          : _formType == FormType.register
                              ? 'Register'
                              : 'Reset',
                      style: TextStyle(
                        color: Color(0XFF0088FF),
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              )),
        ),
      ),
    );
  }
  Future<bool> errorDialog(context, message) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          Future.delayed(Duration(seconds: 3), () {
            Navigator.of(context).pop(true);
          });
          return AlertDialog(
            backgroundColor: kBackgroundColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
            ),
          );
        });
  }
}
