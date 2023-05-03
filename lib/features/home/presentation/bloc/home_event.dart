part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class StartRecordingEvent extends HomeEvent {
  const StartRecordingEvent();

  @override
  List<Object> get props => [];
}

class StopRecordingEvent extends HomeEvent {
  const StopRecordingEvent();

  @override
  List<Object> get props => [];
}
