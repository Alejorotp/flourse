import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'i_local_preferences.dart';

class LocalPreferencesSecured implements ILocalPreferences {
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.unlocked,
    ),
  );

  @override
  Future<T?> retrieveData<T>(String key) async {
    final raw = await _storage.read(key: key);
    if (raw == null) return null;

    if (T == String) {
      return raw as T;
    } else if (T == bool) {
      return (raw.toLowerCase() == 'true') as T;
    } else if (T == int) {
      return int.tryParse(raw) as T?;
    } else if (T == double) {
      return double.tryParse(raw) as T?;
    } else if (T == List<String>) {
      final List<dynamic> decoded = jsonDecode(raw);
      return decoded.cast<String>() as T;
    } else {
      throw UnsupportedError('Type $T is not supported');
    }
  }

  @override
  Future<void> storeData(String key, dynamic value) async {
    if (value is bool) {
      await _storage.write(key: key, value: value.toString());
    } else if (value is double) {
      await _storage.write(key: key, value: value.toString());
    } else if (value is int) {
      await _storage.write(key: key, value: value.toString());
    } else if (value is String) {
      await _storage.write(key: key, value: value);
    } else if (value is List<String>) {
      await _storage.write(key: key, value: jsonEncode(value));
    } else {
      throw UnsupportedError('Type ${value.runtimeType} is not supported');
    }
  }

  @override
  Future<void> removeData(String key) async => await _storage.delete(key: key);
  @override
  Future<void> clearAll() async => await _storage.deleteAll();
}
