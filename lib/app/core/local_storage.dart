import 'package:hive/hive.dart';

abstract class LocalStorage {
  Future<void> create<T>(String key, T value);
  Future<T> read<T>(String key);
  Future<void> update<T>(String key, T value);
  Future<void> delete(String key);
  Future<void> clear();
}

class LocalStorageImpl implements LocalStorage {
  
  Future<Box> get box async {
    return await Hive.openBox('app');
  }

  @override
  Future<void> create<T>(String key, T value) async {
    final box = await this.box;
    await box.put(key, value);
  }
  
  @override
  Future<void> delete(String key) async {
    final box = await this.box;
    await box.delete(key);
  }
  
  @override
  Future<T> read<T>(String key) async {
    final box = await this.box;
    return box.get(key);
  }
  
  @override
  Future<void> update<T>(String key, T value) async {
    final box = await this.box;
    await box.put(key, value);
  }

  @override
  Future<void> clear() async {
    final box = await this.box;
    await box.clear();
  }
}