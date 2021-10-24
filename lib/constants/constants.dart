import 'package:flutter/material.dart';

// This is a list of colors and gradients.
// These final variables are used in making most of the
// UI for the Settings Screen.

const Color lightCardColor = Color(0xFFEFEFF1);
const Color darkTextColor = Color(0xFF747474);
const Color blackTextColor = Color(0xFF000000);
const Color whiteCardColor = Color(0xFFFFFFFF);
const Color whiteTextColor = Color(0xFFFFFFFF);
const defaultShadowColor = Color(0x99999999);
const Color linkColor = Color(0xFF389CEB);
const Color activeDot = Colors.white;
const Color inactiveDot = Color(0xFFBDBDBD);

//
const Color activeColor = Colors.blue;
const Color disabledColor = Colors.grey;
//
const Color colorBlend01 = Color(0xFFED3C5C);
const Color colorBlend02 = Color(0xFFE1189D);

const Color blue = Color(0xFF389CEB);
const Color yellowishOrange = Color(0xFFF99442);

// global textstyles
const TextStyle defaultTextStyle = TextStyle(
  color: Colors.black,
  fontFamily: 'Nunito',
  fontSize: 16,
  fontWeight: FontWeight.w500,
);

const TextStyle boldTextStyle = TextStyle(
  color: Colors.black,
  fontFamily: 'Nunito',
  fontSize: 18,
  fontWeight: FontWeight.w700,
);

const TextStyle titleStyle = TextStyle(
  color: Colors.black,
  fontFamily: 'Nunito',
  fontSize: 22,
  fontWeight: FontWeight.w700,
);

const TextStyle subTitleStyle = TextStyle(
  color: Colors.black,
  fontFamily: 'Nunito',
  fontSize: 18,
  fontWeight: FontWeight.w700,
);

const TextStyle subHeaderStyle = TextStyle(
  color: Colors.black,
  fontFamily: 'Nunito',
  fontSize: 15,
  fontWeight: FontWeight.w500,
);

const TextStyle mediumCharStyle = TextStyle(
  color: Colors.black,
  fontFamily: 'Nunito',
  fontSize: 15,
  fontWeight: FontWeight.w500,
);

const TextStyle smallCharStyle = TextStyle(
  color: Colors.black,
  fontFamily: 'Nunito',
  fontSize: 13,
  fontWeight: FontWeight.w500,
);

const TextStyle smallBoldedCharStyle = TextStyle(
  color: darkTextColor,
  fontFamily: 'Nunito',
  fontSize: 13,
  fontWeight: FontWeight.w700,
);

const TextStyle mediumBoldedCharStyle = TextStyle(
  color: darkTextColor,
  fontFamily: 'Nunito',
  fontSize: 15,
  fontWeight: FontWeight.w700,
);

const TextStyle headerStyle = TextStyle(
  color: Colors.black,
  fontFamily: 'Nunito',
  fontSize: 24,
  fontWeight: FontWeight.w700,
);

//<@SUGN> This is an optional Gradient variable to be used in conjuction with
// the `GradientWidget` found in the {widgets} folder.
const LinearGradient mainColorGradient = const LinearGradient(
  colors: <Color>[
    colorBlend01,
    colorBlend02,
  ],
);