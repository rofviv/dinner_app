import 'package:flutter_modular/flutter_modular.dart';

import '../../app_module.dart';
import 'bloc/dashboard_bloc.dart';
import 'dashboard_widget.dart';

class DashboardModule extends Module {
  static String route = '/dashboard/';

  @override
  List<Module> get imports => [
        AppModule(),
      ];

  @override
  void binds(i) {
    i.addSingleton(DashboardBloc.new);
  }

  @override
  void routes(r) {
    r.child(
      '/',
      child: (context) => DashboardWidget(
        dashboardBloc: Modular.get<DashboardBloc>(),
      ),
    );
  }
}