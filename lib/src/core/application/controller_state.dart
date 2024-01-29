import 'package:equatable/equatable.dart';

abstract class ControllerState extends Equatable {}

class ControllerStateLoading extends ControllerState {
  @override
  List<Object?> get props => [];
}

class ControllerStateSuccess extends ControllerState {
  @override
  List<Object?> get props => [];
}

class ControllerStateFailure extends ControllerState {
  final String message;

  ControllerStateFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class ControllerStateInitial extends ControllerState {
  @override
  List<Object?> get props => [];
}
