import 'dart:io';

class PlatformUtils {
  static bool isAndroid() => Platform.isAndroid;
  static bool isIOS() => Platform.isIOS;
  static bool isWeb() => identical(0, 0.0); // Vérification simple pour le Web
}
