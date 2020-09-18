import 'package:aquaclean/pages/profile.dart';
import 'package:aquaclean/services/auth.dart';
import 'package:aquaclean/services/crud.dart';
import 'package:aquaclean/style/theme.dart';
import 'package:aquaclean/pages/reservations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SideBar extends StatefulWidget {
  SideBar({Key key, this.userId, this.logoutCallback}) : super(key: key);

  final BaseAuth auth = new Auth();

  final String userId;
  final VoidCallback logoutCallback;
  void _signOut() async {
    try {
      await auth.signOut();
      logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  String userId;
  CrudMethods crudObj = new CrudMethods();
  String userMail;
  String _fullNames;
  String profilPicture;
  String image;
  @override
  void initState() {
    super.initState();
    crudObj.getDataFromUserFromDocument().then((value) {
      Map<String, dynamic> dataMap = value.data;
      setState(() {
        userId = dataMap['userId'];
        userMail = dataMap['email'];
        _fullNames = dataMap['fullNames'];
        profilPicture = dataMap['picture'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              'assets/images/home.png',
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0.0),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF00c6ff).withOpacity(0.9),
                  Color(0xFF0276fd).withOpacity(0.9),
                  Color(0xFF0072ff).withOpacity(0.9),
                  Color(0xFF0276fd).withOpacity(0.9),
                  Color(0xFF004d7a),
                  Color(0xFF051937),
                  Colors.transparent,
                ],
              ),
            ),
            child: ListView(
              children: <Widget>[
                new UserAccountsDrawerHeader(
                  accountEmail: new Text(
                    userMail ?? '',
                    style: TextStyle(fontSize: 15.0),
                  ),
                  accountName: Row(
                    children: <Widget>[
                      new Text(
                        _fullNames ?? '',
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ],
                  ),
                  currentAccountPicture: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: kPrimaryColor,
                        width: 4,
                      ),
                    ),
                    child: new GestureDetector(
                      child: profilPicture != null
                          ? Center(
                              child: new CircleAvatar(
                                backgroundImage:
                                    new NetworkImage(profilPicture),
                                maxRadius: 70.0,
                                minRadius: 60.0,
                              ),
                            )
                          : CircleAvatar(
                              child: Image.asset('assets/images/profile.png'),
                              minRadius: 60,
                              maxRadius: 93,
                            ),
                      onTap: () => print("This is your current account."),
                    ),
                  ),
                  decoration: new BoxDecoration(
                      image: new DecorationImage(
                          image: AssetImage("assets/images/landscape.png"),
                          fit: BoxFit.fill)),
                ),
                ListTile(
                  leading: Icon(Icons.home, color: kPrimaryColor),
                  title: Text('Home',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: kPrimaryColor)),
                  onTap: () => {
                    Navigator.of(context).pop(),
                    Navigator.pushReplacementNamed(context, '/'),
                  },
                ),
                divider(),
                ListTile(
                  leading: Icon(Icons.calendar_today, color: kPrimaryColor),
                  title: Text('Reservations',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: kPrimaryColor)),
                  onTap: () => {
                    Navigator.of(context).pop(),
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Reservations())),
                  },
                ),
                divider(),
                ListTile(
                  leading: Icon(Icons.person, color: kPrimaryColor),
                  title: Text('My Account',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: kPrimaryColor)),
                  onTap: () => {
                    Navigator.of(context).pop(),
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ProfilePage())),
                  },
                ),
                divider(),
                // ListTile(
                //   leading: Icon(Icons.help, color: kPrimaryColor),
                //   title: Text('Get in Touch',
                //       style: TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor)),
                //   onTap: () => {
                //     Navigator.of(context).pop(),
                //     Navigator.push(context,
                //         MaterialPageRoute(builder: (context) => HelpPage())),
                //   },
                // ),
                // divider(),
                ListTile(
                  leading: Icon(Icons.exit_to_app, color: kPrimaryColor),
                  title: Text('Logout',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: kPrimaryColor)),
                  onTap: () async {
                    Navigator.of(context).pop();
                    widget._signOut();
                    Navigator.of(context).pushReplacementNamed('/');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget divider() {
    return Divider(
      color: kPrimaryColor.withOpacity(0.5),
      height: 10,
      indent: 50,
      endIndent: 20,
    );
  }
}
