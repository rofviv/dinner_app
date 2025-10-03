import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:video_player/video_player.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  io.Socket? socket;
  VideoPlayerController? _controller;
  FlutterTts flutterTts = FlutterTts();

  DashboardBloc() : super(const DashboardState()) {
    on<OnIsLoadingEvent>((event, emit) {
      emit(state.copyWith(isLoading: event.isLoading));
    });

    on<OnLoadVideoEvent>((event, emit) async {
      _controller?.dispose();
      _controller = VideoPlayerController.file(File("/home/nvidia-jpac2/Videos/${event.filename}"));
      await _controller!.initialize();
      await _controller!.setLooping(true);
      await _controller!.play();
      emit(state.copyWith(
        videoController: _controller,
        isLoading: false,
      ));
    });

    on<OnSpeakEvent>((event, emit) async {
      emit(state.copyWith(textToSpeak: event.text));
      await flutterTts.awaitSpeakCompletion(true);
      await flutterTts.speak(event.text);
      emit(state.copyWith(textToSpeak: ""));
    });

    _init();
  }

  void _init() async {
    _onConnectSocket();
    add(OnLoadVideoEvent(filename: "normal.mp4"));
  }

  Future<void> _initTTS() async {
    await flutterTts.setLanguage("es-ES");
    List<dynamic> voices = await flutterTts.getVoices;
    print(voices);
    await flutterTts.setVoice({"name": "Samantha", "locale": "en-US"});

    await flutterTts.setSpeechRate(1.0);
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.awaitSynthCompletion(true);

    var result = await flutterTts.speak("Hola, ¿cómo estás?");
    print(result);

    // await _tts.setLanguage("es-ES");
    // await _tts.setSpeechRate(0.9);
  }

  Future<void> _onConnectSocket() async {
    socket?.disconnect();
    socket = io.io(
      "http://localhost:5001",
      io.OptionBuilder().setTransports(['websocket']).setExtraHeaders(
          {'Origin': '*'}).build(),
    );

    socket!.on("video", (data) {
      add(OnLoadVideoEvent(filename: data['filename']));
    });

    socket!.on("speak", (data) {
      add(OnSpeakEvent(text: data['text']));
    });
  }

  @override
  Future<void> close() {
    _controller?.dispose();
    return super.close();
  }
}
