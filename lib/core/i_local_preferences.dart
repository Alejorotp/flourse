abstract class ILocalPreferences {
  Future<T?> retrieveData<T>(String key);

  Future<void> storeData(String key, dynamic value);

  Future<void> removeData(String key);

  Future<void> clearAll();
}
