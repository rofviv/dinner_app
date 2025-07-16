part of 'splash_bloc.dart';

class SplashState extends Equatable {
  final String? errorMessage;

  const SplashState({this.errorMessage});

  SplashState copyWith({String? errorMessage}) {
    return SplashState(errorMessage: errorMessage ?? this.errorMessage);
  }

  @override
  List<Object?> get props => [errorMessage];
}