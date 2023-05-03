part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class RecordingState extends HomeState {
  final String note;
  final String status;

  const RecordingState({
    required this.note,
    required this.status,
  });

  @override
  List<Object> get props => [note, status];
}
class NotRecordingState extends HomeState {}

class RE extends HomeState {}
