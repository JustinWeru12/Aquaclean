import 'package:aquaclean/pages/reservations.dart';
import 'package:aquaclean/services/crud.dart';
import 'package:aquaclean/services/jobData.dart';
import 'package:aquaclean/style/animatedCard.dart';
import 'package:aquaclean/style/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:location/location.dart';
import 'package:transparent_image/transparent_image.dart';

class Hire extends StatefulWidget {
  @override
  _HireState createState() => _HireState();
}

class _HireState extends State<Hire> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool _isLoading = false, _allowLocation = true;
  String name, description, town;
  Location location = new Location();
  Geoflutterfire geo = Geoflutterfire();
  PermissionStatus _permissionGranted;
  LocationData currentLocation;
  CrudMethods crudObj = new CrudMethods();

  addReservation(service,picture,price) {
    getLocation().then((value) {
      if (_allowLocation) {
        GeoFirePoint point = geo.point(
          latitude: value.latitude,
          longitude: value.longitude,
        );

        ResData resData = new ResData(
            name: name,
            description: description,
            service: service,
            town: town,
            picture: picture,
            price: price,
            location: point.data);
        crudObj.createReservation(resData.getResDataMap());
      } else {
        ResData resData = new ResData(
            name: name,
            description: description,
            service: service,
            town: town,
            picture: picture,
            price: price,
            location: null);
        crudObj.createReservation(resData.getResDataMap());
      }
      Navigator.of(context).pop();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Reservations()));
    });
  }

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    _requestPermission();
    location = new Location();
  }

  Future<void> _checkLocationPermission() async {
    final PermissionStatus permissionGrantedResult =
        await location.hasPermission();
    setState(() {
      _permissionGranted = permissionGrantedResult;
    });
  }

  Future<void> _requestPermission() async {
    if (_permissionGranted != PermissionStatus.granted) {
      final PermissionStatus permissionRequestedResult =
          await location.requestPermission();
      setState(() {
        _permissionGranted = permissionRequestedResult;
      });
      if (permissionRequestedResult != PermissionStatus.granted) {
        return;
      }
    }
  }

  getLocation() async {
    currentLocation = await location.getLocation();
    return currentLocation;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: new AppBar(
        title: Text(
          'Hire Us',
          style: kAppBarstyle,
        ),
        bottomOpacity: 1,
        centerTitle: true,
        iconTheme: new IconThemeData(color: Colors.white),
        elevation: 0.0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF0072ff),
              Color(0xFF0276fd),
              Color(0xFF00c6ff),
            ],
          )),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: StreamBuilder(
              stream: Firestore.instance.collection('services').snapshots(),
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        physics: ScrollPhysics(),
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, i) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 8),
                            child: AnimatedCard(
                              color: Colors.white,
                              width: size.width * 0.8,
                              topCardHeight: 400,
                              bottomCardHeight: 200,
                              borderRadius: 20,
                              topCardWidget: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(18.0),
                                    child: FadeInImage.memoryNetwork(
                                      placeholder: kTransparentImage,
                                      image: snapshot
                                          .data.documents[i].data['pictures'],
                                      fit: BoxFit.cover,
                                      height: 400,
                                      width: size.width * 0.8,
                                    ),
                                  ),
                                  Container(
                                    height: 400,
                                    width: size.width * 0.8,
                                    decoration: BoxDecoration(
                                      //color: Colors.white,
                                      gradient: LinearGradient(
                                        begin: FractionalOffset.topCenter,
                                        end: FractionalOffset.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.transparent,
                                          Colors.black,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                  Container(
                                    constraints: BoxConstraints(
                                      maxWidth: size.width * 0.8,
                                      maxHeight: 400,
                                    ),
                                    padding: EdgeInsets.only(
                                        top: 0,
                                        left: 15,
                                        right: 15,
                                        bottom: 25),
                                    child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Text(
                                          snapshot
                                              .data.documents[i].data['name']
                                              .toUpperCase(),
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                          overflow: TextOverflow.fade,
                                          textAlign: TextAlign.center,
                                        )),
                                  ),
                                ],
                              ),
                              bottomCardWidget: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                        snapshot
                                            .data.documents[i].data['location'],
                                        style: kHeadingTextStyle),
                                    divider(),
                                    Text(
                                      snapshot.data.documents[i]
                                          .data['description'],
                                      style: kBodyTextstyle,
                                      textAlign: TextAlign.center,
                                    ),
                                    RaisedButton(
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          Icon(
                                            FontAwesomeIcons.penFancy,
                                            color: Color(0xFF004d7a),
                                          ),
                                          Text('Hire')
                                        ],
                                      ),
                                      color: Color(0xFFebdffc),
                                      textColor: Colors.black87,
                                      onPressed: () {
                                        _showModalBottomSheet(snapshot
                                            .data.documents[i].data['name'],snapshot.data.documents[i].data['pictures'],snapshot
                                            .data.documents[i].data['price']);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              slimeEnabled: true,
                            ),
                          );
                        })
                    : Container(
                        margin: EdgeInsets.only(top: 18.0),
                        child: CircularProgressIndicator());
              }),
        ),
      ),
    );
  }

  void _showModalBottomSheet(service,picture,price) {
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
                padding: EdgeInsets.only(
                    left: 30,
                    right: 30,
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFFFFFFF),
                        Color(0xFF00c6ff),
                        Color(0xFF0276fd),
                        // Color(0xFF0072ff),
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
                            service.toUpperCase(),
                            style: kTitleTextstyle,
                          ),
                          Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: Text(
                                  "This app wishes to store the location of your business to help in finding you quicker",
                                  style: kBodyTextstyle,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Switch(
                                value: _allowLocation,
                                onChanged: (bool value) {
                                  setState(() {
                                    _allowLocation = value;
                                    print(_allowLocation);
                                  });
                                },
                                activeColor: Colors.lightBlueAccent,
                              ),
                            ],
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
                                  return 'Enter Your Name/Business';
                                }
                                return null;
                              },
                              onSaved: (value) => name = value,
                              decoration: InputDecoration(
                                filled: false,
                                contentPadding: EdgeInsets.all(10),
                                enabledBorder: _borders,
                                focusedBorder: _borders,
                                hintText: 'Name/Business',
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
                              maxLines: 3,
                              initialValue: 'None',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'Enter a Description of Services Required';
                                }
                                return null;
                              },
                              onSaved: (value) => description = value,
                              decoration: InputDecoration(
                                filled: false,
                                contentPadding: EdgeInsets.all(10),
                                enabledBorder: _borders,
                                focusedBorder: _borders,
                                hintText: 'Additional Description',
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
                              onSaved: (value) => town = value,
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
                          _isLoading == false
                              ? RaisedButton(
                                  color: mainColor,
                                  child: Text(
                                    'Add',
                                    style: kContentTextstyle,
                                  ),
                                  splashColor: kthirdrcolor,
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      _formKey.currentState.save();
                                      addReservation(service, picture,price.toString());
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

  Widget divider() {
    return Divider(
      color: Colors.black,
      height: 30,
      indent: 0,
      endIndent: 0,
    );
  }
}
