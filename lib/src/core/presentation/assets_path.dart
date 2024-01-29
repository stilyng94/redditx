import 'package:flutter/material.dart';

abstract class AssetsPath {
  static const logo = 'assets/images/logo.png';
  static const googleIcon = 'assets/images/google.png';

  static const bannerDefault =
      'https://thumbs.dreamstime.com/b/abstract-stained-pattern-rectangle-background-blue-sky-over-fiery-red-orange-color-modern-painting-art-watercolor-effe-texture-123047399.jpg';
  static const avatarDefault =
      'https://external-preview.redd.it/5kh5OreeLd85QsqYO1Xz_4XSLYwZntfjqou-8fyBFoE.png?auto=webp&s=dbdabd04c399ce9c761ff899f5d38656d1de87c2';

  static const IconData up = IconData(0xe800, fontFamily: 'MyFlutterApp');
  static const IconData down = IconData(0xe801, fontFamily: 'MyFlutterApp');

  static const awardsPath = 'assets/images/awards';

  static const awards = {
    'awesomeAns': '${AssetsPath.awardsPath}/awesomeanswer.png',
    'gold': '${AssetsPath.awardsPath}/gold.png',
    'platinum': '${AssetsPath.awardsPath}/platinum.png',
    'helpful': '${AssetsPath.awardsPath}/helpful.png',
    'plusone': '${AssetsPath.awardsPath}/plusone.png',
    'rocket': '${AssetsPath.awardsPath}/rocket.png',
    'thankyou': '${AssetsPath.awardsPath}/thankyou.png',
    'til': '${AssetsPath.awardsPath}/til.png',
  };
}
