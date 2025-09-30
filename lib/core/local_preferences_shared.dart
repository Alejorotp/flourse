import 'package:shared_preferences/shared_preferences.dart';

import 'i_local_preferences.dart';

class LocalPreferencesShared implements ILocalPreferences {
  late SharedPreferencesAsync prefs;

  LocalPreferencesShared() {
    prefs = SharedPreferencesAsync();
  }

  @override
  Future<T?> retrieveData<T>(String key) async {
    if (T == bool) {
      return await prefs.getBool(key) as T?;
    } else if (T == double) {
      return await prefs.getDouble(key) as T?;
    } else if (T == int) {
      return await prefs.getInt(key) as T?;
    } else if (T == String) {
      return await prefs.getString(key) as T?;
    } else if (T == List<String>) {
      return await prefs.getStringList(key) as T?;
    } else {
      throw Exception("Unsupported type");
    }
  }

  @override
  Future<void> storeData(String key, dynamic value) async {
    if (value is bool) {
      await prefs.setBool(key, value);
      //logInfo("LocalPreferences setBool with key $key got $result");
    } else if (value is double) {
      await prefs.setDouble(key, value);
      //logInfo("LocalPreferences setDouble with key $key got $result");
    } else if (value is int) {
      await prefs.setInt(key, value);
      //logInfo("LocalPreferences setInt with key $key got $result");
    } else if (value is String) {
      await prefs.setString(key, value);
      //logInfo("LocalPreferences setString with key $key got $result");
    } else if (value is List<String>) {
      await prefs.setStringList(key, value);
      //logInfo("LocalPreferences setStringList with key $key got $result");
    } else {
      throw Exception("Unsupported type");
    }
  }

  @override
  Future<void> removeData(String key) async => await prefs.remove(key);
  @override
  Future<void> clearAll() async => await prefs.clear();
}
