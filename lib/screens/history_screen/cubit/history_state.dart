import 'package:equatable/equatable.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();
  @override
  List<Object?> get props => [];
}

class HistoryLoadingState extends HistoryState {}

class HistoryLoadedState extends HistoryState {
  final List<Map<String, dynamic>> items;
  const HistoryLoadedState(this.items);
  @override
  List<Object?> get props => [items];
}

class HistoryErrorState extends HistoryState {
  final String message;
  const HistoryErrorState(this.message);
  @override
  List<Object?> get props => [message];
}