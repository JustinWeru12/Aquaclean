import 'dart:math';

import 'package:aquaclean/pages/sidebar.dart';
import 'package:aquaclean/services/auth.dart';
import 'package:aquaclean/services/crud.dart';
import 'package:aquaclean/style/theme.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final logoutCallback;
  final String userId;
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
  int amount, amountDue, rate, income;
  String category, payRate, _userId;
  bool _isPro = false;
  var paymentrates = [
    'Annually',
    'Halfly',
    'Quarterly',
    'Monthly',
  ];
  List<String> categories = ['Personal', 'Loans', 'Overdues', 'Bills'];

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
    crudObj.getDataFromProfFromDocumentWithID(widget.userId).then((value) {
      if (value.data != null) {
        setState(() {
          _isPro = true;
        });
      }
    });
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
          Positioned.fill(
            child: Container(
              color: Colors.grey[200],
            ),
          ),
          Image.asset(
            'assets/bg.jpg',
            height: MediaQuery.of(context).size.height * 0.55,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Align(
              alignment: Alignment(0, 0.80),
              child: _isPro
                  ? _buildTiles(
                      side, mainColor, 'Edit\nProfession.', null)
                  : _buildTiles(side, mainColor, 'Join Us.', null)),
          Align(
              alignment: Alignment(0.8, 0.45),
              child: _buildTiles(side, kfirstColor, 'Rate', null)),
          Align(
              alignment: Alignment(-0.8, 0.45),
              child: _buildTiles(side, ksecondColor, 'Request Service', null)),
          Align(
              alignment: Alignment(0, 0.10),
              child: _buildTiles(side, kthirdrcolor, 'Hire', null)),
          Align(alignment: Alignment(0, -0.88), child: textBox()),
          Align(
            alignment: Alignment(-0.9, -0.9),
            child: InkWell(
              onTap: () => _scaffoldKey.currentState.openDrawer(),
              child: Transform.rotate(
                angle: pi / 4,
                child: Material(
                  elevation: 5,
                  shadowColor: Colors.black,
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: side * 0.12,
                    width: side * 0.12,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.lime,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    child: Transform.rotate(
                        angle: -pi / 4,
                        child: Icon(
                          Icons.menu,
                          color: Colors.lime,
                        )),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
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
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 25))),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0),
            child: Icon(
              Icons.camera,
              color: appOrange,
              size: 90,
            ),
          ),
          Container(
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'The home of freelancers\nwe offer you short_term services with ultimate professionalism to guarantee your satisfaction\n\nSelect The Best From Our Comprehensive Talent',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              )),
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
}
