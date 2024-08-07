import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ThemeIcons {
  static Image get logo => Image.asset(
        "icons/logo.png",
      );

  static Image logo2({double? height, Color? color}) => Image.asset(
        'icons/logo.png',
        height: height,
        color: color,
      );

  // a
  static IconData get android => const IconDataBrands(0xf17b);
  static IconData get apple => const IconDataBrands(0xf179);
  static IconData get area => FontAwesomeIcons.fileShield;
  static IconData get attach => FontAwesomeIcons.fileArrowUp;
  // b
  static IconData get back => const IconDataSolid(0xf060);
  // c
  static IconData get camera => FontAwesomeIcons.camera;
  static IconData get cancel => FontAwesomeIcons.ban;
  static IconData get cartPlus => FontAwesomeIcons.cartShopping;
  static IconData get check => FontAwesomeIcons.check;
  static IconData get checkSquare => const IconDataSolid(0xf14a);
  static IconData get checkToSlot => const IconDataSolid(0xf772);
  static IconData get chrome => const IconDataBrands(0xf268);
  static IconData get clearCache => const IconDataSolid(0xf12d);
  static IconData get clockwise => FontAwesomeIcons.rotateLeft;
  static IconData get close => FontAwesomeIcons.xmark;
  static IconData get copyPosition => const IconDataRegular(0xf0c5);
  static IconData get counterClockwise => FontAwesomeIcons.rotateRight;
  static IconData get crop => const IconDataSolid(0xf565);
  // d
  static IconData get database => const IconDataSolid(0xf1c0);
  static IconData get defaultUser => const IconDataRegular(0xf007);
  static IconData get deletePosition => FontAwesomeIcons.trashCan;
  static IconData get dissatisfied => FontAwesomeIcons.disease;
  static IconData get docType => FontAwesomeIcons.fileInvoice;
  static IconData get down => FontAwesomeIcons.downLong;
  // e
  static IconData get edge => const IconDataBrands(0xf282);
  static IconData get email => FontAwesomeIcons.share;
  static IconData get envelopeReceiver => FontAwesomeIcons.envelopeOpenText;
  static IconData get envelopeSender => FontAwesomeIcons.envelopesBulk;
  static IconData get exit => FontAwesomeIcons.rightFromBracket;
  static IconData get externLink => const IconDataSolid(0xf08e);
  // f
  static IconData get file => FontAwesomeIcons.file;
  static IconData get fileAdd => FontAwesomeIcons.fileCirclePlus;
  static IconData get fileDownload => FontAwesomeIcons.fileArrowDown;
  static IconData get fileExport => FontAwesomeIcons.fileExport;
  static IconData get fileImport => FontAwesomeIcons.fileImport;
  static IconData get filePDF => FontAwesomeIcons.filePdf;
  static IconData get firebase => const IconDataRegular(0xf0e0);
  static IconData get firefox => const IconDataBrands(0xf269);
  // h
  static IconData get hitlist => const IconDataSolid(0xf03a);
  static IconData get home => FontAwesomeIcons.houseChimney;
  // i
  static IconData get info => FontAwesomeIcons.circleInfo;
  static IconData get invitation => FontAwesomeIcons.userPlus;
  // k
  static IconData get key => FontAwesomeIcons.key;
  // l
  static IconData get lang => FontAwesomeIcons.globe;
  static IconData get linux => const IconDataBrands(0xf17c);
  static IconData get lock => FontAwesomeIcons.lock;
  static IconData get lockOpen => FontAwesomeIcons.lockOpen;
  // m
  static IconData get menu => FontAwesomeIcons.bars;
  static IconData get microsoft => const IconDataBrands(0xf17a);
  static IconData get microsoft2 => const IconDataBrands(0xf3ca);
  static IconData get mobile => const IconDataSolid(0xf3ce);
  static IconData get multiLineMinus => FontAwesomeIcons.circleMinus;
  static IconData get multiLinePlus => FontAwesomeIcons.circlePlus;
  // n
  static IconData get newPosition => FontAwesomeIcons.plus;
  static IconData get newspaper => FontAwesomeIcons.newspaper;
  static IconData get noObscure => FontAwesomeIcons.eyeSlash;
  static IconData get notifications => FontAwesomeIcons.bell;
  // o
  static IconData get obscure => FontAwesomeIcons.eye;
  static IconData get off => FontAwesomeIcons.toggleOff;
  static IconData get on => FontAwesomeIcons.toggleOn;
  static IconData get opera => const IconDataSolid(0xf26a);
  static IconData get passwordLock => FontAwesomeIcons.unlock;
  // p
  static IconData get pin => const IconDataSolid(0xf08d);
  // r
  static IconData get reload => FontAwesomeIcons.rotate;
  static IconData get reply => FontAwesomeIcons.reply;
  // s
  static IconData get safari => const IconDataBrands(0xf267);
  static IconData get scanner => const IconData(0xe554, fontFamily: 'MaterialIcons');
  static IconData get searchFilter => FontAwesomeIcons.filter;
  static IconData get send => Icons.send;
  static IconData get sendAlt => const IconDataSolid(0xe20a);
  static IconData get settings => FontAwesomeIcons.sliders;
  static IconData get smallSearch => FontAwesomeIcons.magnifyingGlass;
  static IconData get swfCorrection => const IconDataSolid(0xf772);
  static IconData get swfCreation => const IconDataSolid(0xf07a);
  static IconData get swfDuplicateCheck => const IconDataSolid(0xf560);
  static IconData get swfError => const IconDataSolid(0xf06a);
  static IconData get swfExport => const IconDataSolid(0xf56e);
  static IconData get swfFinish => const IconDataSolid(0xf494);
  static IconData get swfGoodsCheck => const IconDataSolid(0xf4de);
  static IconData get swfPurchase => const IconDataSolid(0xf0d6);
  static IconData get swfRelease => const IconDataSolid(0xf508);
  // t
  static IconData get task => const IconDataSolid(0xf0ae);
  static IconData get tasks => const IconDataSolid(0xf0ae);
  static IconData get toggleOff => FontAwesomeIcons.toggleOff;
  static IconData get toggleOn => FontAwesomeIcons.toggleOn;
  // u
  static IconData get up => FontAwesomeIcons.upLong;
  static IconData get user => FontAwesomeIcons.userLarge;
  static IconData get userLock => FontAwesomeIcons.userLock;
  static IconData get userPen => FontAwesomeIcons.userPen;
  static IconData get userSlash => FontAwesomeIcons.userSlash;
  static IconData get userUnlock => FontAwesomeIcons.unlockKeyhole;
  // w
  static IconData get web => const IconDataSolid(0xf0ac);
  static IconData get windows => const IconDataBrands(0xf17a);
  // random access
  static IconData iconData(int codePoint) => IconDataSolid(codePoint);
}
