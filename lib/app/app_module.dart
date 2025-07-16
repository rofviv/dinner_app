import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'core/local_storage.dart';
import 'core/preferences_repository.dart';
import 'modules/dashboard/dashboard_module.dart';
import 'modules/splash/splash_module.dart';

class AppModule extends Module {

  @override
  void exportedBinds(i) {
    i.addLazySingleton<Dio>(
      () => Dio(
        BaseOptions(
          baseUrl: '',
        ),
      ),
    );
    i.addSingleton<LocalStorage>(LocalStorageImpl.new);
    i.addSingleton<PreferencesRepository>(PreferencesRepositoryImpl.new);
  }
  
  @override
  void routes(r) {
    r.module(SplashModule.route, module: SplashModule());
    r.module(DashboardModule.route, module: DashboardModule());
  }
}