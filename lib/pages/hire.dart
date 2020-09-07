import 'package:aquaclean/style/animatedCard.dart';
import 'package:aquaclean/style/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transparent_image/transparent_image.dart';

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
      body: StreamBuilder(
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
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 8),
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
                                    top: 0, left: 15, right: 15, bottom: 25),
                                child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Text(
                                      snapshot.data.documents[i].data['name']
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
                                    snapshot.data.documents[i].data['location'],
                                    style: kHeadingTextStyle),
                                divider(),
                                Text(
                                  snapshot
                                      .data.documents[i].data['description'],
                                  style: kBodyTextstyle,
                                  textAlign: TextAlign.center,
                                ),
                                RaisedButton(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
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
                                  onPressed: (){},
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
    );
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
