part of 'dashboard_bloc.dart';

class DashboardState extends Equatable {
  final bool isLoading;
  final VideoPlayerController? videoController;
  final String? textToSpeak;

  const DashboardState({
    this.isLoading = true,
    this.videoController,
    this.textToSpeak,
  });

  DashboardState copyWith({
    bool? isLoading,
    VideoPlayerController? videoController,
    String? textToSpeak,
  }) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      videoController: videoController ?? this.videoController,
      textToSpeak: textToSpeak ?? this.textToSpeak,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        videoController,
        textToSpeak,
      ];
}
