import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

import 'bloc/dashboard_bloc.dart';

class DashboardWidget extends StatelessWidget {
  const DashboardWidget({super.key, required this.dashboardBloc});
  static String route = '/';

  final DashboardBloc dashboardBloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          BlocBuilder<DashboardBloc, DashboardState>(
            bloc: dashboardBloc,
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.videoController == null) {
                return const Center(
                  child: Text('Video "c:\\videos\\normal.mp4" not found'),
                );
              }

              return Center(
                child: AspectRatio(
                  aspectRatio: state.videoController!.value.aspectRatio,
                  child: VideoPlayer(state.videoController!),
                ),
              );
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BlocBuilder<DashboardBloc, DashboardState>(
              bloc: dashboardBloc,
              builder: (context, state) {
                if ((state.textToSpeak??"").isEmpty) {
                  return SizedBox();
                }
                return AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Text(
                    (state.textToSpeak ?? '').toUpperCase(),
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      //floatingActionButton: FloatingActionButton(
      //  onPressed: () {
      //    dashboardBloc.add(
      //        const OnLoadVideoEvent(filename: 'normal.mp4'));
      //  },
      //  child: const Icon(Icons.play_arrow),
      //),
    );
  }
}
