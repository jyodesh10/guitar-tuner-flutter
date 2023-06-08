// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_audio_capture/flutter_audio_capture.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';
import 'package:pitchupdart/instrument_type.dart';
import 'package:pitchupdart/pitch_handler.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final _audioRecorder = FlutterAudioCapture();
  final pitchDetectorDart = PitchDetector(44100, 2000);
  final pitchupDart = PitchHandler(InstrumentType.guitar);

  var note = "";
  var status = "Click on start";
  HomeBloc() : super(HomeInitial()) {
    on<HomeEvent>((event, emit) {});
    on<StartRecordingEvent>((event, emit)async {
        await _audioRecorder.start(listener, error,
        sampleRate: 44100, bufferSize: 3000);

    note = "";
    status = "Play something";
    emit(RecordingState(note: note, status: status) );
      // _startCapture();
    });
    on<StopRecordingEvent>((event, emit) {
      emit(NotRecordingState());
      _stopCapture();
    });
  }



  void listener(dynamic obj) {
    var buffer = Float64List.fromList(obj.cast<double>());
    final List<double> audioSample = buffer.toList();

    final result = pitchDetectorDart.getPitch(audioSample);

    if (result.pitched) {
      final handledPitchResult = pitchupDart.handlePitch(result.pitch);

      note = handledPitchResult.note;
      log("note:$note");
      status = handledPitchResult.tuningStatus.toString();
      log("status:$status");
          emit(RecordingState(note: note, status: status));
    }
  }

  Future<void> _stopCapture() async {
    await _audioRecorder.stop();

    note = "";
    status = "Click on start";
  }

  void error(Object e) {
    if (kDebugMode) {
      print(e);
    }
  }
}
