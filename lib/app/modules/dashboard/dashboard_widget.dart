import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fullscreen/flutter_fullscreen.dart';
import 'package:video_player/video_player.dart';

import 'bloc/dashboard_bloc.dart';

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({super.key, required this.dashboardBloc});
  static String route = '/';
  final DashboardBloc dashboardBloc;

  @override
  State<DashboardWidget> createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  bool showOverlay = true;

  void handleFadeOutOverlay() {
    setState(() {
      showOverlay = false;
    });
  }

  void resetOverlay() {
    if (!showOverlay) {
      setState(() {
        showOverlay = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          BlocBuilder<DashboardBloc, DashboardState>(
            bloc: widget.dashboardBloc,
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.videoController == null) {
                return const Center(
                  child: Text(
                    'Video "c:\\videos\\normal.mp4" not found',
                    style: TextStyle(color: Colors.white),
                  ),
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
            bottom: 40,
            left: 20,
            right: 20,
            child: BlocBuilder<DashboardBloc, DashboardState>(
              bloc: widget.dashboardBloc,
              builder: (context, state) {
                final text = (state.textToSpeak ?? '').trim();
                final hasText = text.isNotEmpty;

                if (hasText) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    resetOverlay();
                  });
                }

                return AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: hasText ? 1.0 : 0.0,
                  curve: Curves.easeInOut,
                  child: AnimatedScale(
                    duration: const Duration(milliseconds: 500),
                    scale: hasText ? 1.0 : 0.8,
                    curve: Curves.easeOutBack,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 24),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: KaraokeText(
                        text: text.toUpperCase(),
                        wordDelay: const Duration(milliseconds: 300),
                        baseStyle: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w400,
                          color: Colors.white60,
                          letterSpacing: 0.3,
                        ),
                        highlightedStyle: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                        onStartFadeOut: handleFadeOutOverlay,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          Positioned(
            top: 10,
            left: 10,
            width: 300,
            height: 300,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () async {
                FullScreen.setFullScreen(false);
              },
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }
}

// Karaoke text highlighting
class KaraokeText extends StatefulWidget {
  final String text;
  final Duration wordDelay;
  final TextStyle baseStyle;
  final TextStyle highlightedStyle;
  final VoidCallback? onStartFadeOut;

  const KaraokeText({
    super.key,
    required this.text,
    this.wordDelay = const Duration(milliseconds: 300),
    required this.baseStyle,
    required this.highlightedStyle,
    this.onStartFadeOut,
  });

  @override
  State<KaraokeText> createState() => _KaraokeTextState();
}

class _KaraokeTextState extends State<KaraokeText> {
  int highlightedWords = 0;
  bool animationFinished = false;

  @override
  Future<void> initState() async {
    FullScreen.setFullScreen(true);
    super.initState();
    _startHighlighting();
  }

  void _startHighlighting() async {
    final words = widget.text.trim().split(' ');
    final total = words.length;
    final fadeOutDelay = Duration(
      milliseconds: max(0, widget.wordDelay.inMilliseconds * total - 500),
    );

    Future.delayed(fadeOutDelay, () {
      if (mounted) widget.onStartFadeOut?.call();
    });

    for (int i = 0; i < total; i++) {
      if (!mounted) return;
      setState(() {
        highlightedWords = i + 1;
      });
      await Future.delayed(widget.wordDelay);
    }

    if (mounted) {
      setState(() {
        animationFinished = true;
      });
    }
  }

  @override
  void didUpdateWidget(covariant KaraokeText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      highlightedWords = 0;
      animationFinished = false;
      _startHighlighting();
    }
  }

  @override
  Widget build(BuildContext context) {
    final words = widget.text.trim().split(' ');

    return Wrap(
      alignment: WrapAlignment.center,
      runSpacing: 8,
      spacing: 6,
      children: List.generate(words.length, (i) {
        final isSpoken = i + 1 == highlightedWords && !animationFinished;
        final isHighlighted = i < highlightedWords;

        return TweenAnimationBuilder<double>(
          tween: Tween<double>(
            begin: 1.0,
            end: isSpoken ? 1.10 : 1.0,
          ),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutBack,
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 250),
                style: isHighlighted
                    ? widget.highlightedStyle
                    : widget.baseStyle,
                child: Text(words[i]),
              ),
            );
          },
        );
      }),
    );
  }
}