part of 'fen_cubit.dart';

sealed class FenState extends Equatable {
  const FenState();

  @override
  List<Object> get props => [];
}

final class FenInitial extends FenState {}

final class FenUpdated extends FenState {
  final String fen;

  const FenUpdated({required this.fen});
}