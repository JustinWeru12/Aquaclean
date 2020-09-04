import 'package:aquaclean/style/animatedCard.dart';
import 'package:aquaclean/style/theme.dart';
import 'package:flutter/material.dart';

class Hire extends StatefulWidget {
  @override
  _HireState createState() => _HireState();
}

class _HireState extends State<Hire> {
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
        padding: EdgeInsets.symmetric(vertical: 10),
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
                child: Container(
                  color: Colors.green,
                  height: 400,
                  width: size.width * 0.8,
                  child: Image.asset(
                    'assets/images/bg.jpg',
                    fit: BoxFit.cover,
                  ),
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
                padding:
                    EdgeInsets.only(top: 0, left: 15, right: 15, bottom: 25),
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      'Sample Text',
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
          bottomCardWidget: Text('Sample Text', style: kHeadingTextStyle),
          slimeEnabled: true,
        ),
      ),
    );
  }
}
