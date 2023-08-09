import 'package:flutter/material.dart';

const themePrimaryColor = nord10Frost; //       #5E81AC
const themeSecondaryColor = nord8Frost; //      #88C0D0
const themeSignalColor = nord12AuroraOrange; // #D08770
const themeTextColor = nord1PolarNight; //      #2E3440

const themeGrey1Color = nord0PolarNight; //     #2E3440
const themeGrey2Color = nord1PolarNight; //     #3B4252
const themeGrey3Color = nord2PolarNight; //     #434C5E
const themeGrey4Color = nord3PolarNight; //     #4C566A

const themeBorderColor = nord1PolarNight; //    #3B4252

const nord0PolarNight = Color(0xff2E3440); // #2E3440
const nord1PolarNight = Color(0xff3B4252); // #3B4252
const nord2PolarNight = Color(0xff434C5E); // #434C5E
const nord3PolarNight = Color(0xff4C566A); // #4C566A

const nord4SnowStorm = Color(0xffD8DEE9); //  #D8DEE9
const nord5SnowStorm = Color(0xffE5E9F0); //  #E5E9F0
const nord6SnowStorm = Color(0xffECEFF4); //  #ECEFF4

const nord7Frost = Color(0xff8FBCBB); //      #8FBCBB
const nord8Frost = Color(0xff88C0D0); //      #88C0D0
const nord9Frost = Color(0xff81A1C1); //      #81A1C1
const nord10Frost = Color(0xff5E81AC); //     #5E81AC

const nord11AuroraRed = Color(0xFFBF616A); //    #BF616A
const nord12AuroraOrange = Color(0xFFD08770); // #D08770
const nord13AuroraYellow = Color(0xFFEBCB8B); // #EBCB8B
const nord14AuroraGreen = Color(0xFFA3BE8C); //  #A3BE8C
const nord15AuroraPurple = Color(0xFFB48EAD); // #B48EAD

MaterialColor toMaterialColor(Color c) {
  Map<int, Color> swatch = {
    50: c.withAlpha(25),
    100: c.withAlpha(50),
    200: c.withAlpha(75),
    300: c.withAlpha(100),
    400: c.withAlpha(125),
    500: c.withAlpha(150),
    600: c.withAlpha(175),
    700: c.withAlpha(200),
    800: c.withAlpha(225),
    900: c.withAlpha(250),
  };

  return MaterialColor(c.value, swatch);
}
