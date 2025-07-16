part of 'splash_bloc.dart';

abstract class SplashEvent extends Equatable {
  const SplashEvent();

  @override
  List<Object> get props => [];
}

class SplashErrorEvent extends SplashEvent {
  final String errorMessage;

  const SplashErrorEvent({required this.errorMessage});
}