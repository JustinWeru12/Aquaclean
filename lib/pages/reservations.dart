import 'dart:math';

import 'package:aquaclean/services/auth.dart';
import 'package:aquaclean/style/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class Reservations extends StatefulWidget {
  final BaseAuth auth = new Auth();
  @override
  _ReservationsState createState() => _ReservationsState();
}

class _ReservationsState extends State<Reservations> {
  String userId;
  void initState() {
    super.initState();
    widget.auth.currentUser().then((id) {
      setState(() {
        userId = id;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var halfSide = MediaQuery.of(context).size.width / 2;
    var side = halfSide * sqrt(2);
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: new AppBar(
        title: Text(
          'Reservations',
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
        child: StreamBuilder(
            stream: Firestore.instance
                .collection('user')
                .document(userId)
                .collection('reservations')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.documents.length <= 0) {
                  return Container(
                    child: Center(
                      child: Text("You have not added any Reservations 😞"),
                    ),
                  );
                } else {
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, i) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            // height: 100,
                            padding: EdgeInsets.zero,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFF0072ff).withOpacity(0.9),
                                      Color(0xFF0276fd).withOpacity(0.9),
                                      Color(0xFF00c6ff).withOpacity(0.9),
                                    ]),
                                //color: Theme.of(context).primaryColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              // leading:
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15.0),
                                    child: FadeInImage.memoryNetwork(
                                      placeholder: kTransparentImage,
                                      image: snapshot
                                          .data.documents[i].data['picture'],
                                      fit: BoxFit.cover,
                                      width: 80.0,
                                      height: 100.0,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              snapshot.data.documents[i]
                                                  .data['service'],
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                              )),
                                          Text(
                                              snapshot
                                                  .data.documents[i].data['name'],
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                              )),
                                          Text(
                                              snapshot
                                                  .data.documents[i].data['town'],
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Transform.rotate(
                                      angle: pi / 4,
                                      child: Material(
                                        elevation: 5,
                                        shadowColor: Colors.black,
                                        color: kthirdrcolor,
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          height: side * 0.15,
                                          width: side * 0.15,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.blue,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Transform.rotate(
                                              angle: -pi / 4,
                                              child: Center(
                                                child: Text(
                                                    snapshot.data.documents[i]
                                                        .data['price'],
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )),
                                              )),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              //   subtitle: Column(
                              //     children: [],
                              //   ),
                              // trailing:
                              //   onTap: () {},
                            ),
                          ),
                        );
                      });
                }
              } else {
                return CircularProgressIndicator();
              }
            }),
      ),
    );
  }
}
