import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {}

class AuthStateInitial extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthStateUnAuthenticated extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthStateAuthenticated extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthStateFailure extends AuthState {
  final String message;

  AuthStateFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthStateLoading extends AuthState {
  AuthStateLoading();

  @override
  List<Object?> get props => [];
}
