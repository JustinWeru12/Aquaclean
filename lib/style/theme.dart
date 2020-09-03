import 'package:flutter/material.dart';

// Colors
const kBackgroundColor = Color(0xFFE9D5CA);
const kTitleTextColor = Color(0xFF303030);
const kBodyTextColor = Color(0xFF4B4B4B);
const kTextLightColor = Color(0xFF959595);
const kInfectedColor = Color(0xFFFF8748);
const kDeathColor = Color(0xFFFF4848);
const kRecovercolor = Color(0xFF36C12C);
const kPrimaryColor = Color(0xFFa8eb12);
const kAppBarColor = Color(0xFF11249F);
const mainColor = Color(0xFF004d7a);
const kfirstColor = Color(0xFF008793);
const ksecondColor = Color(0xFF00bf72);
const kthirdrcolor = Color(0xFFa8eb12);
final kShadowColor = Color(0xFFB7B7B7).withOpacity(.16);
final kActiveShadowColor = Color(0xFF4056C6).withOpacity(.15);
const Color loginGradientStart = const Color(0xFFfbab66);
const Color loginGradientEnd = const Color(0xFFf7418c);
const appOrange = const Color(0xFFFF5733);

// Text Style
const kHeadingTextStyle = TextStyle(
  fontSize: 22,
  fontWeight: FontWeight.w600,
);

const kSubTextStyle = TextStyle(fontSize: 16, color: kTextLightColor);
const kAlertTextStyle = TextStyle(fontSize: 16, color: kDeathColor);

const kTitleTextstyle = TextStyle(
  fontSize: 18,
  color: kTitleTextColor,
  fontWeight: FontWeight.bold,
);

const kContentTextstyle = TextStyle(
  fontSize: 18,
  color: kBackgroundColor,
  fontWeight: FontWeight.w600,
);

const kAppBarstyle = TextStyle(
  fontSize: 20,
  color: kBackgroundColor,
  fontWeight: FontWeight.bold,
);

  const primaryGradient = const LinearGradient(
    colors: const [loginGradientStart, loginGradientEnd],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
