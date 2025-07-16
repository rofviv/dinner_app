import 'package:flutter_modular/flutter_modular.dart';

import '../../app_module.dart';
import 'bloc/splash_bloc.dart';
import 'splash_widget.dart';

class SplashModule extends Module {
  static String route = '/';

  @override
  List<Module> get imports => [
        AppModule(),
      ];

  @override
  void binds(i) {
    i.addSingleton(SplashBloc.new);
  }

  @override
  void routes(r) {
    r.child(
      SplashWidget.route,
      child: (context) => SplashWidget(
        splashBloc: Modular.get<SplashBloc>(),
      ),
    );
  }
}