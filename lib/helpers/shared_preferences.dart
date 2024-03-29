import 'package:shared_preferences/shared_preferences.dart';

class SharedPre {
  static String num1Key = 'JIDJFIDJOFJSEIJI#JR';
  static String num2Key = 'isdjfiweojrur93u9';
  static String num3Key = 'ij3rjj398wurjijsdfo';
  static String isSafeKey = 'isdjfisjfjefsjfidsljf';
  static Future<bool> saveNumbers(String num1, String num2, String num3) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(num1Key, num1);
    await pref.setString(num2Key, num2);
    await pref.setString(num3Key, num3);
    return true;
  }

  static Future<bool> isSafeSet(bool safeness) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool(isSafeKey, safeness);
    return true;
  }

  static Future<bool?> isSafeGet() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.getBool(isSafeKey);
  }

  static Future<List<String?>> getNumbers() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String?> nums = List<String?>.filled(3, null);
    nums[0] = await pref.getString(num1Key);
    nums[1] = await pref.getString(num2Key);
    nums[2] = await pref.getString(num3Key);
    return nums;
  }
}
