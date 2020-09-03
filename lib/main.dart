import 'package:flutter/foundation.dart';
import 'package:aquaclean/pages/rootpage.dart';
import 'package:aquaclean/services/auth.dart';
import 'package:aquaclean/style/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wiredash/wiredash.dart';

void main() {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _navigatorKey = GlobalKey<NavigatorState>();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Wiredash(
      projectId: 'aquaclean-ye3ze5t',
      secret: 'yxfak6i97e8n2qz5qsmjruruoalmq5v5',
      theme: WiredashThemeData(
        backgroundColor: Colors.lime,
        primaryColor: Color(0xFF004d7a),
        secondaryColor: Color(0xFF00bf72),
        dividerColor: Colors.indigo,
        // brightness: Brightness.dark,
      ),
      options: WiredashOptionsData(
        showDebugFloatingEntryPoint: false,
      ),
      navigatorKey: _navigatorKey,
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'aquaclean',
          navigatorKey: _navigatorKey,
          initialRoute: '/',
          routes: {
            '/root': (context) => RootPage(),
          },
          theme: ThemeData(
              scaffoldBackgroundColor: kBackgroundColor,
              canvasColor: kBackgroundColor.withOpacity(0.9),
              fontFamily: "Poppins",
              textTheme: TextTheme(
                bodyText1: TextStyle(color: kBodyTextColor),
              )),
          home: new RootPage(auth: new Auth())),
    );
  }
}
