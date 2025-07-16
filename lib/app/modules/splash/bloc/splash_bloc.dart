import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../dashboard/dashboard_module.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(const SplashState()) {
    on<SplashErrorEvent>((event, emit) {
      emit(state.copyWith(errorMessage: event.errorMessage));
    });

    _init();
  }

  _init() async {
    await Future.delayed(const Duration(seconds: 2));
    Modular.to.navigate(DashboardModule.route);
  }
}