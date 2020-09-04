import 'package:aquaclean/style/theme.dart';
import 'package:flutter/material.dart';

class JoinUs extends StatefulWidget {
  @override
  _JoinUsState createState() => _JoinUsState();
}

class _JoinUsState extends State<JoinUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: new AppBar(
        title: Text(
          'Join',
          style: kAppBarstyle,
        ),
        bottomOpacity: 1,
        centerTitle: true,
        iconTheme: new IconThemeData(color: Colors.green),
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
      body: Container(
        child: _card()
      ),
    );
  }
  Widget _card(){
    return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              // gradient: LinearGradient(
              //   begin: Alignment.topRight,
              //   end: Alignment.bottomLeft,
              //   colors: [
              //     Color(0xFF00bf72),
              //     Color(0xFF008793),
              //     Color(0xFF004d7a),
              //   ],
              // ),
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey,
                  offset: Offset(10.0, 10.0),
                  blurRadius: 5.0,
                )
              ],
            ),
            child: new Center(
              child: new Icon(
                Icons.refresh,
                size: 50.0,
              ),
            ),
          ),
        );
  }
}
