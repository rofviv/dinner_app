import 'local_storage.dart';

abstract class PreferencesRepository {
  Future<String?> get token;
  Future<String?> get userId;


  Future<void> setToken(String token);
  Future<void> setUserId(String userId);


  Future<void> clearSession();
}

class PreferencesRepositoryImpl implements PreferencesRepository {
  final LocalStorage _localStorage;

  final String _tokenKey = 'app-token';
  final String _userIdKey = 'app-user-id';

  PreferencesRepositoryImpl(this._localStorage);

  @override
  Future<void> clearSession() async {
    await _localStorage.clear();
  }

  @override
  Future<void> setToken(String token) async {
    await _localStorage.create(_tokenKey, token);
  }

  @override
  Future<String?> get token => _localStorage.read<String?>(_tokenKey);

  @override
  Future<void> setUserId(String userId) async {
    await _localStorage.create(_userIdKey, userId);
  }

  @override
  Future<String?> get userId => _localStorage.read<String?>(_userIdKey);

}