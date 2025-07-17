part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class OnIsLoadingEvent extends DashboardEvent {
  final bool isLoading;
  const OnIsLoadingEvent({required this.isLoading});
}

class OnLoadVideoEvent extends DashboardEvent {
  final String filename;

  const OnLoadVideoEvent({required this.filename});
}

class OnSpeakEvent extends DashboardEvent {
  final String text;
  final bool useEleventLabs;
  const OnSpeakEvent({required this.text, required this.useEleventLabs});
}
