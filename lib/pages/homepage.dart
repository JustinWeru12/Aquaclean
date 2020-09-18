import 'dart:io';
import 'dart:math';

import 'package:aquaclean/pages/hire.dart';
import 'package:aquaclean/pages/joinus.dart';
import 'package:aquaclean/pages/rate.dart';
import 'package:aquaclean/pages/request.dart';
import 'package:aquaclean/pages/sidebar.dart';
import 'package:aquaclean/services/auth.dart';
import 'package:aquaclean/services/crud.dart';
import 'package:aquaclean/services/jobData.dart';
import 'package:aquaclean/style/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  HomePage(
      {Key key, this.auth, this.userId, this.logoutCallback, this.isRegister})
      : super(key: key);

  final BaseAuth auth;
  final logoutCallback;
  final String userId;
  final bool isRegister;
  void _signOut() async {
    try {
      await auth.signOut();
      logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // ignore: unused_field
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  CrudMethods crudObj = CrudMethods();
  String _userId, userDataId = '';
  String description;
  String name;
  List<String> pictures;
  String location;
  int price;
  bool _isPro = false;
  bool _isLoading = false;
  File newProfilPic;
  final picker = ImagePicker();

  @override
  void initState() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid;
        print(_userId);
      });
    });
    profCheck();
    super.initState();
  }

  profCheck() {
    crudObj.getDataFromUserFromDocument().then((value) {
      Map<String, dynamic> dataMap = value.data;
      setState(() {
        _isPro = dataMap['admin'];
        userDataId = dataMap['userId'];
        print(_isPro);
        if (userDataId == null) {
          updateId();
        }
      });
    });
  }

  updateId() {
    crudObj.createOrUpdateUserData({'userId': _userId});
  }

  @override
  Widget build(BuildContext context) {
    var halfSide = MediaQuery.of(context).size.width / 2;
    var side = halfSide * sqrt(2);
    return Scaffold(
      backgroundColor: kBackgroundColor,
      key: _scaffoldKey,
      drawer: SideBar(
        logoutCallback: widget._signOut,
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Image.asset(
            'assets/bg.webp',
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0.0),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Color(0xFFE9D5CA),
                    Color(0xFFE9D5CA),
                  ],
                ),
              ),
            ),
          ),
          Align(
              alignment: Alignment(0, 0.60),
              child: _buildTiles(side, mainColor, 'Join Us.', JoinUs())),
          Align(
              alignment: Alignment(0.8, 0.25),
              child: _buildTiles(side, kfirstColor, 'Rate', Rate())),
          Align(
              alignment: Alignment(-0.8, 0.25),
              child: _buildTiles(
                  side, ksecondColor, 'Request Service', Request())),
          Align(
              alignment: Alignment(0, -0.10),
              child: _buildTiles(side, kthirdrcolor, 'Hire', Hire())),
          Align(alignment: Alignment(0, 1), child: textBox()),
          Align(
            alignment: Alignment(-0.9, -0.9),
            child: InkWell(
              onTap: () => _scaffoldKey.currentState.openDrawer(),
              child: Transform.rotate(
                angle: pi / 4,
                child: Material(
                  elevation: 5,
                  shadowColor: Colors.black,
                  color: kthirdrcolor,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: side * 0.12,
                    width: side * 0.12,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.blue,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    child: Transform.rotate(
                        angle: -pi / 4,
                        child: Icon(
                          Icons.menu,
                          color: Colors.blue,
                        )),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _isPro
          ? FloatingActionButton(
              onPressed: () => setState(() {
                _showModalBottomSheet();
              }),
              tooltip: 'Increment Counter',
              child: Icon(Icons.add),
            )
          : Container(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }

  Widget textBox() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
              child: Text('Welcome to aquaclean'.toUpperCase(),
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                      fontSize: 25))),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Your Absolute Cleaning Experience.\nWe offer you cleaming services with ultimate professionalism to guarantee your satisfaction.',
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                  fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTiles(side, color, text, route) {
    return InkWell(
      onTap: () {
        print('tapped');
        Navigator.push(context, MaterialPageRoute(builder: (context) => route));
      },
      child: Transform.rotate(
        angle: pi / 4,
        child: Material(
          elevation: 5,
          shadowColor: Colors.black,
          color: color,
          borderRadius: BorderRadius.circular(32),
          child: Container(
            height: side * 0.5,
            width: side * 0.5,
            child: Transform.rotate(
              angle: -pi / 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  uploadImage() async {
    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('jobPics/$name.jpg');
    final StorageUploadTask task = firebaseStorageRef.putFile(newProfilPic);
    if (task.isInProgress) {
      setState(() {
        _isLoading = true;
      });
    }
    var downloadUrl = await (await task.onComplete).ref.getDownloadURL();
    var url = downloadUrl.toString();
    setState(() {
      _isLoading = false;
    });
    return url;
  }

  void addService(url) {
    JobData jobData = new JobData(
        name: name,
        description: description,
        location: location,
        price: price,
        pictures: url);
    crudObj.createService(jobData.getJobDataMap());
  }

  Widget enableUpload() {
    return Container(
      child: Column(
        children: <Widget>[
          Image.file(
            newProfilPic,
            height: 200,
            width: 200,
          ),
          _isLoading == false
              ? Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: RaisedButton(
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    child: Icon(
                      Icons.done,
                      color: Color(0xFF0fbc00),
                    ),
                    color: Color(0xFFe0fcdf),
                    textColor: Colors.black87,
                    onPressed: () {},
                  ),
                )
              : Container(
                  margin: EdgeInsets.only(top: 18.0),
                  child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  void _showModalBottomSheet() {
    var _borders = OutlineInputBorder(
        borderSide: BorderSide(
          color: mainColor,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(5));
    showModalBottomSheet(
        isDismissible: true,
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return SingleChildScrollView(
              child: Container(
                // height: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(left: 30,right:30,bottom: MediaQuery.of(context).viewInsets.bottom),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(0.7),
                        Colors.white.withOpacity(0.8),
                        Colors.white
                      ]),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(25.0),
                    topRight: const Radius.circular(25.0),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Add a Service',
                            style: kTitleTextstyle,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'Enter the Name of the Service';
                                }
                                return null;
                              },
                              onSaved: (value) => name = value,
                              decoration: InputDecoration(
                                filled: false,
                                contentPadding: EdgeInsets.all(10),
                                enabledBorder: _borders,
                                focusedBorder: _borders,
                                hintText: 'Name of Service',
                                hintStyle: TextStyle(
                                  color: mainColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () async {
                                var tempImage = await picker.getImage(
                                    source: ImageSource.gallery);
                                setState(() {
                                  newProfilPic = File(tempImage.path);
                                });
                              },
                              child: newProfilPic == null
                                  ? RaisedButton(
                                      elevation: 5.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30.0),
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          Icon(
                                            Icons.camera_alt,
                                            color: Color(0xFF008793),
                                          ),
                                          Text('Select picture'),
                                        ],
                                      ),
                                      color: Color(0xFFebdffc),
                                      textColor: Colors.black87,
                                      onPressed: () async {
                                        var tempImage = await picker.getImage(
                                            source: ImageSource.gallery);
                                        setState(() {
                                          newProfilPic = File(tempImage.path);
                                        });
                                      })
                                  : enableUpload(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              maxLines: 5,
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'Enter the Description';
                                }
                                return null;
                              },
                              onSaved: (value) => description = value,
                              decoration: InputDecoration(
                                filled: false,
                                contentPadding: EdgeInsets.all(10),
                                enabledBorder: _borders,
                                focusedBorder: _borders,
                                hintText: 'Description',
                                hintStyle: TextStyle(
                                  color: mainColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'Enter the Location';
                                }
                                return null;
                              },
                              onSaved: (value) => location = value,
                              decoration: InputDecoration(
                                filled: false,
                                contentPadding: EdgeInsets.all(10),
                                enabledBorder: _borders,
                                focusedBorder: _borders,
                                hintText: 'Location',
                                hintStyle: TextStyle(
                                  color: mainColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'Enter the Price';
                                }
                                return null;
                              },
                              onSaved: (value) => price = int.tryParse(value),
                              decoration: InputDecoration(
                                filled: false,
                                contentPadding: EdgeInsets.all(10),
                                enabledBorder: _borders,
                                focusedBorder: _borders,
                                hintText: 'Price',
                                hintStyle: TextStyle(
                                  color: mainColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          _isLoading == false
                              ? RaisedButton(
                                  color: mainColor,
                                  child: Text(
                                    'Add',
                                    style: kContentTextstyle,
                                  ),
                                  splashColor: kthirdrcolor,
                                  onPressed: () {
                                    if (newProfilPic == null) {
                                      _showDialogMissingPhoto();
                                    } else {
                                      if (_formKey.currentState.validate()) {
                                        _formKey.currentState.save();
                                        uploadImage().then((value) {
                                          addService(value);
                                          Navigator.of(context).pop();
                                        });
                                      }
                                    }
                                  },
                                )
                              : Container(
                                  margin: EdgeInsets.only(top: 18.0),
                                  child: CircularProgressIndicator()),
                        ],
                      )),
                ),
              ),
            );
          });
        });
  }

  void _showDialogMissingPhoto() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.only(top: 8.0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Photo missing",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "A photo is required!",
                  textAlign: TextAlign.justify,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    child: new Text(
                      "Ok",
                      style: TextStyle(color: Colors.blue),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
