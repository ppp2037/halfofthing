import 'package:steel_crypt/steel_crypt.dart';

make_ivslat() {
  var ivsalt = CryptKey().genDart(length: 16); //generate iv for AES using Dart Random.secure()
  return ivsalt;
}

make_key() {
  var FortunaKey = CryptKey().genFortuna();
  return FortunaKey;
}

String make_encryption(String password, var ivsalt, var fortunakey) {

  var aesEncrypter = AesCrypt(mode: ModeAES.cbc, padding: PaddingAES.iso78164, key: fortunakey);


  var crypted = aesEncrypter.encrypt(password, iv: ivsalt);
  return crypted;
}
