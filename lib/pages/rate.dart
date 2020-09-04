
import 'package:aquaclean/style/theme.dart';
import 'package:flutter/material.dart';

class Rate extends StatefulWidget {
  @override
  _RateState createState() => _RateState();
}

class _RateState extends State<Rate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: new AppBar(
        title: Text(
          'Rate',
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
        padding: EdgeInsets.symmetric(vertical: 10.0),
        
      ),
    );
  }
}
