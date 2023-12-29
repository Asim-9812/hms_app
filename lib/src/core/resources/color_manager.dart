import 'package:flutter/material.dart';

class ColorManager {

  static Color primary = HexColor.fromHex("#28A89C");
  static Color primaryOpacity80 = HexColor.fromHex('#28A89C');
  static Color primaryDark = HexColor.fromHex('#28A89C');
  static Color splashColor = HexColor.fromHex('#10A194').withOpacity(0.8);
  static Color searchColor = HexColor.fromHex('#49EBDC');
  static Color lightGreen = HexColor.fromHex('#D8E9A8');
  static Color brightGreen = HexColor.fromHex("#49EBDC");
  static Color inputGreen = HexColor.fromHex('#F0F7DE');
  static Color greenOpacity5 = HexColor.fromHex('#56B995').withOpacity(0.05);
  static Color greenNotification = HexColor.fromHex('#F6FBF9');
  static Color white = HexColor.fromHex('#ffffff');
  static Color listTile = HexColor.fromHex('#F9F8F8').withOpacity(0.5);
  static Color tileGreen = HexColor.fromHex('#EDF8EF');
  static Color blue = HexColor.fromHex('#42bcea');
  static Color lightBlueAccent = HexColor.fromHex('#28A89C');
  static Color blueText = HexColor.fromHex('#28A89C');
  static Color red = HexColor.fromHex('#FF0000');
  static Color brightRed = HexColor.fromHex('#FF5733');
  static Color black = HexColor.fromHex('#36454F');
  static Color blackOpacity15 = HexColor.fromHex('#000000').withOpacity(0.15);
  static Color blackOpacity19 = HexColor.fromHex('#000000').withOpacity(0.19);
  static Color blackOpacity25 = HexColor.fromHex('000000').withOpacity(0.25);
  static Color blackOpacity80 = HexColor.fromHex('#000000').withOpacity(0.80);
  static Color blackOpacity70 = HexColor.fromHex('#000000').withOpacity(0.70);
  static Color dotGrey = HexColor.fromHex('#D8D8D8');
  static Color textGrey = HexColor.fromHex('##646864');
  static Color iconGrey = HexColor.fromHex('#000000').withOpacity(0.6);
  static Color subtitleGrey = HexColor.fromHex('#838589');
  static Color borderGreen = HexColor.fromHex('#DEDEDE');
  static Color scaffolColor = HexColor.fromHex('#FFFFFF');
  static Color blueGray = HexColor.fromHex('#6699CC');
  static Color chipColor = HexColor.fromHex('#E0E0E0').withOpacity(0.5);
  static Color successBadgeBg = HexColor.fromHex('#C6F6D5');
  static Color successBadgeText = HexColor.fromHex('#22543D');
  static Color errorBadgeBg = HexColor.fromHex('#FED7D7');
  static Color errorBadgeText = HexColor.fromHex('#822727');
  static Color pendingBadgeBg = HexColor.fromHex('#E9D8FD');
  static Color pendingBadgeText = HexColor.fromHex('#44337A');
  static Color yellowFellow = HexColor.fromHex('#FFD090');
  static Color brightYellow = HexColor.fromHex('#f5f500');
  static Color brightPink = HexColor.fromHex('#FCCBFF');
  static Color blueContainer = HexColor.fromHex('#A8E1FF');
  static Color goldContainer = HexColor.fromHex('#B8994A');
  static Color silver = HexColor.fromHex('#acacac').withOpacity(0.6);
  static Color silverContainer = HexColor.fromHex('#949087').withOpacity(0.8);
  static Color premiumContainer = HexColor.fromHex('#BA7A7A').withOpacity(0.8);
  static Color trialContainer = HexColor.fromHex('#261D1D').withOpacity(0.8);
  static Color blackContainer = HexColor.fromHex('#1A1717');
  static Color accentRed = HexColor.fromHex('#eb6060');
  static Color accentYellow = HexColor.fromHex('#f7e463');
  static Color accentGreen = HexColor.fromHex('#7cd992');
  static Color accentPurple = HexColor.fromHex('#b8586a');
  static Color accentCream = HexColor.fromHex('#f4bccc');
  static Color accentBlue = HexColor.fromHex('#6194eb');
  static Color accentPink = HexColor.fromHex('#be60eb');
  static Color accentLightGreen = HexColor.fromHex('#00c781');
  static Color accentOrange = HexColor.fromHex('#f96856');
  static Color orange = HexColor.fromHex('#FF8C00');
}

extension HexColor on Color {
  static Color fromHex(String hexColorString) {
    hexColorString = hexColorString.replaceAll('#', '');
    if (hexColorString.length == 6) {
      hexColorString = "FF" + hexColorString; // 8 char with opacity 100%
    }
    return Color(int.parse(hexColorString, radix: 16));
  }
}
